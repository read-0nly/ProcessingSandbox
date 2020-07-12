

import processing.sound.*;

SoundFile song;
FFT fft;
int bands = 512;
float factor = 30;
float bandWidth = 2;
float threshhold = 0.7;
float[] spectrum = new float[bands];
float[] maximums = new float[bands];
boolean direction = true;
PImage myMovie;

void settings() {
  myMovie = loadImage("D:\\Media\\Pictures\\Pictures\\blackbird_by_mezamero-d4albr9.jpg");
  size(myMovie.width, myMovie.height);
}
void setup(){ 
  background(0);
  song = new SoundFile(this, "D:\\Media\\Music\\P.O.S. Complete Discography\\P.O.S.- Never Better\\02-p.o.s.-drumroll_(were_all_thirsty).mp3");
  song.loop();
  fft = new FFT(this, bands);
  fft.input(song); 
  myMovie.loadPixels();
}

void draw() {
  loadPixels(); 
  fft.analyze(spectrum);

  println( spectrum[0] );
  
 for( int y = 0; y < height; y++){
   for( int x = 0; x < width; x++){
     int loc =  x + y*width;
     float yChunk = y/(height/((bands/bandWidth)));
     if(spectrum[int(yChunk)%bands] > maximums[int(yChunk)%bands]){
       maximums[int(yChunk)%bands] = spectrum[int(yChunk)%bands]; 
     }
     float normalized = spectrum[int(yChunk)%bands] * (1/maximums[int(yChunk)%bands]);
     int multi = -1+(int(direction)*2);
     normalized = multi * normalized;
     direction = !direction;
     int loc2 = x + y*width + int(normalized*factor);
     if (loc2<0){
      loc2 = loc2+(width*height); 
     }
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
