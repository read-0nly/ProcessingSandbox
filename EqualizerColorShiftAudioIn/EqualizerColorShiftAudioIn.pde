

import processing.sound.*;

AudioIn song;
FFT fft;
int bands = 256;
float[] spectrum = new float[bands];
float[] maximums = new float[bands];
int direction = 1;
PImage myMovie;

void settings() {
  myMovie = loadImage("D:\\Glitch\\targets\\Konachan.com - 255367 black_hair dress long_hair original realistic red_eyes shal.e watermark.jpg");
  size(myMovie.width, myMovie.height);
}
void setup(){ 
  background(0);
  song = new AudioIn(this,1);
  song.start();
  fft = new FFT(this, bands);
  fft.input(song); 
}

void draw() {
  loadPixels(); 
  myMovie.loadPixels();
  fft.analyze(spectrum);

  println( spectrum[0] );
  
 for( int y = 0; y < height; y++){
   for( int x = 0; x < width; x++){
     int loc =  x + y*width;
     float yChunk = y/(height/((bands/2.0f)));
     if(spectrum[int(yChunk)%bands] > maximums[int(yChunk)%bands]){
       maximums[int(yChunk)%bands] = spectrum[int(yChunk)%bands]; 
     }
     float normalized = spectrum[int(yChunk)%bands] * (1/maximums[int(yChunk)%bands]);
     normalized = direction * normalized;
     direction = 0-direction;
     int loc2 = x + y*width + int(normalized*25);
      loc2 = loc2+(width*height); 
     pixels[loc] = color(red(myMovie.pixels[(loc2%(width*height))]), green(myMovie.pixels[loc]),blue(myMovie.pixels[loc]));
   }
 
 }
  updatePixels();
  
  /*
  for(int i = 0; i < bands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  line( i, height, i, height - spectrum[i] );
  } */
  
}

public class TestClass{

}
