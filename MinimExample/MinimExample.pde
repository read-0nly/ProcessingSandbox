/**
  * Colorshifting visualizer!
  */

import ddf.minim.*;
import ddf.minim.analysis.*;
import javax.swing.JOptionPane; 

Minim minim;
AudioPlayer player;
FFT fft;
float[] maximums;
int lastPos =0;
boolean direction = true;
boolean flipping = true;
PImage myMovie;
int bands = 0;
float factor = 30;
float bandWidth = 2.5;
float threshold = 0.3;
boolean fftTransform = false;
boolean shiftRed = false;
boolean shiftBlue = false;
boolean shiftGreen = true;

void settings() {
  myMovie = loadImage( JOptionPane.showInputDialog("Enter Image Path").replace("\"",""));
  size(myMovie.width, myMovie.height);
}
void setup()
{
  background(0);
  myMovie.loadPixels();
  
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
  // loadFile will look in all the same places as loadImage does.
  // this means you can find files that are in the data folder and the 
  // sketch folder. you can also pass an absolute path, or a URL.
  player = minim.loadFile(JOptionPane.showInputDialog("Enter Song Path").replace("\"",""));
  fft = new FFT( player.bufferSize(), player.sampleRate() );
  maximums = new float[player.bufferSize()];
  bands = player.bufferSize();
}

void draw()
{
  stroke(255);
  background(0);
  loadPixels();   
  myMovie.loadPixels();
  if(fftTransform){
  fft.forward(player.mix);  
   for( int y = 0; y < height; y++){
     for( int x = 0; x < width; x++){
       int loc =  x + y*width;
       float yChunk = y/(height/((bands/bandWidth)));
       if(fft.getBand(int(yChunk)%bands) > maximums[int(yChunk)%bands]){
         maximums[int(yChunk)%bands] = fft.getBand(int(yChunk)%bands); 
       }
       float normalized = fft.getBand(int(yChunk)%bands) * (1/maximums[int(yChunk)%bands]);
       if(normalized < threshold && normalized > -threshold){normalized = 0;}
       if(flipping){
         int multi = -1+(int(direction)*2);
         normalized = multi * normalized;
         direction = !direction;
       }
       int loc2 = x + y*width + int(normalized*factor);
       if (loc2<0){
        loc2 = loc2+(width*height); 
       }
       float newRed = red(myMovie.pixels[loc]);
       float newGreen = green(myMovie.pixels[loc]);
       float newBlue = blue(myMovie.pixels[loc]);
       if(shiftRed){
         newRed = red(myMovie.pixels[(loc2%(width*height))]);
       }
       if(shiftGreen){
         newGreen = green(myMovie.pixels[(loc2%(width*height))]);
       }
       if(shiftBlue){
         newBlue = blue(myMovie.pixels[(loc2%(width*height))]);
       }
       pixels[loc] = color(newRed, newGreen,newBlue);
     }
   }
  }
  else{  
   for( int y = 0; y < height; y++){
     for( int x = 0; x < width; x++){
       int loc =  x + y*width;
       float yChunk = y/(height/((bands/bandWidth)));
       if(player.left.get(int(yChunk)%bands) > maximums[int(yChunk)%bands]){
         maximums[int(yChunk)%bands] = player.left.get(int(yChunk)%bands); 
       }
       float normalized = player.left.get(int(yChunk)%bands) * (1/maximums[int(yChunk)%bands]);
       if(normalized < threshold && normalized > -threshold){normalized = 0;}
       if(flipping){
         int multi = -1+(int(direction)*2);
         normalized = multi * normalized;
         direction = !direction;
       }
       int loc2 = x + y*width + int(normalized*factor);
       while (loc2<0){
        loc2 = loc2+((width*height)); 
       }
       float newRed = red(myMovie.pixels[loc]);
       float newGreen = green(myMovie.pixels[loc]);
       float newBlue = blue(myMovie.pixels[loc]);
       if(shiftRed){
         newRed = red(myMovie.pixels[(loc2%(width*height))]);
       }
       if(shiftGreen){
         newGreen = green(myMovie.pixels[(loc2%(width*height))]);
       }
       if(shiftBlue){
         newBlue = blue(myMovie.pixels[(loc2%(width*height))]);
       }
       pixels[loc] = color(newRed, newGreen,newBlue);
     }
   }
  }
    
   updatePixels();
  if (player.position() > player.length()-1000 && !player.isPlaying() )
  {
    println("end");
    player.rewind();
    //text("Press any key to pause playback.", 10, 20 );
  }
  else
  {
    println(player.position()+" : "+player.length() + " - isplaying: "+ player.isPlaying()  );
   // text("Press any key to start playback.", 10, 20 );
  }
}

void keyPressed()
{
  if ( player.isPlaying() )
  {
    player.pause(); //<>//
  }
  // if the player is at the end of the file,
  // we have to rewind it before telling it to play again
  else if ( player.position() == player.length() )
  {
    player.rewind();
    player.play();
  }
  else
  {
    player.play();
  }
}
