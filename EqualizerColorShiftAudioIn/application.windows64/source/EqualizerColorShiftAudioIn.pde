
import processing.sound.*;
import java.util.Date;
long drawFrame;
Date dt = new Date();

AudioIn song;
FFT fft;
Waveform wvf;
int bands = 256;
float[] spectrum = new float[bands];
float[] maximums = new float[bands];
int direction = 1;
float mediator = 0.7;
float bleed = 0.999999;
PImage myMovie;

void settings() {
  myMovie = loadImage(".\\SEELE.png");
  size(myMovie.width, myMovie.height);
}
void setup(){ 
  background(0);
    drawFrame =System.currentTimeMillis();
  song = new AudioIn(this,1);
  wvf = new Waveform(this, bands);
  wvf.input(song); 
  song.start();
}

void draw() {
  myMovie.loadPixels();
  loadPixels(); 
  wvf.analyze(spectrum);
 if(System.currentTimeMillis()-drawFrame>1){
 for( int y = 0; y < height; y++){
     float yChunk = y/(height/((bands/2.0f)));
     if(spectrum[int(yChunk)%bands] > maximums[int(yChunk)%bands]){
       maximums[int(yChunk)%bands] = spectrum[int(yChunk)%bands]; 
     }
     float normalized = 0 ;
     if((maximums[int(yChunk)%bands]*mediator)>0){
       normalized = spectrum[int(yChunk)%bands] * (1/(maximums[int(yChunk)%bands]*mediator));
     }
     if(normalized > 1){
      normalized = 1; 
     }
     normalized = direction * normalized;
     direction = 0-direction;
   for( int x = 0; x < width; x++){
     int loc =  x + y*width;
     int loc2 = x + (y*width) + int(normalized*25);
      loc2 = loc2+(width*height);
      float r = red(myMovie.pixels[loc]);
      float g = green(myMovie.pixels[(loc2%(width*height))]);//myMovie.pixels[loc]);
      float b = blue(myMovie.pixels[(loc2%(width*height))]);//myMovie.pixels[loc]);
     pixels[loc] = color(r,g,b);
     maximums[int(yChunk)%bands] = maximums[int(yChunk)%bands] * bleed;
   }
 
 }
  updatePixels();
  drawFrame =System.currentTimeMillis();
  }
  
  /*
  for(int i = 0; i < bands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  line( i, height, i, height - spectrum[i] );
  } */
  
}

public class TestClass{

}
