

import processing.sound.*;

SoundFile song;
FFT fft;
int bands = 256;
float[] spectrum = new float[bands];
float[] maximums = new float[bands];
boolean direction = true;
PImage myMovie;

void settings() {
  myMovie = loadImage("D:\\Glitch\\targets\\Konachan.com - 309793 sample.jpg");
  size(myMovie.width, myMovie.height);
}
void setup(){ 
  background(0);
  song = new SoundFile(this, "D:\\Media\\Music\\Grandson - a modern tragedy vol. 1 (2018) [320]\\01. Blood  Water.mp3");
  song.loop();
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
     float yChunk = y/(height/((bands/1.0f)));
     if(spectrum[int(yChunk)%bands] > maximums[int(yChunk)%bands]){
       maximums[int(yChunk)%bands] = spectrum[int(yChunk)%bands]; 
     }
     float normalized = spectrum[int(yChunk)%bands] * (1/maximums[int(yChunk)%bands]);
     int multi = -1+(int(direction)*2);
     normalized = multi * normalized;
     direction = !direction;
     int loc2 = x + y*width + int(normalized*50);
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
