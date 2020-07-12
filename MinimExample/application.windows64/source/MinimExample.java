import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 
import javax.swing.JOptionPane; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MinimExample extends PApplet {

/**
  * Colorshifting visualizer!
  */



 

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
float bandWidth = 2.5f;
float threshold = 0.3f;
boolean fftTransform = false;
boolean shiftRed = false;
boolean shiftBlue = false;
boolean shiftGreen = true;

public void settings() {
  myMovie = loadImage( JOptionPane.showInputDialog("Enter Image Path").replace("\"",""));
  size(myMovie.width, myMovie.height);
}
public void setup()
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

public void draw()
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
       if(fft.getBand(PApplet.parseInt(yChunk)%bands) > maximums[PApplet.parseInt(yChunk)%bands]){
         maximums[PApplet.parseInt(yChunk)%bands] = fft.getBand(PApplet.parseInt(yChunk)%bands); 
       }
       float normalized = fft.getBand(PApplet.parseInt(yChunk)%bands) * (1/maximums[PApplet.parseInt(yChunk)%bands]);
       if(normalized < threshold && normalized > -threshold){normalized = 0;}
       if(flipping){
         int multi = -1+(PApplet.parseInt(direction)*2);
         normalized = multi * normalized;
         direction = !direction;
       }
       int loc2 = x + y*width + PApplet.parseInt(normalized*factor);
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
       if(player.left.get(PApplet.parseInt(yChunk)%bands) > maximums[PApplet.parseInt(yChunk)%bands]){
         maximums[PApplet.parseInt(yChunk)%bands] = player.left.get(PApplet.parseInt(yChunk)%bands); 
       }
       float normalized = player.left.get(PApplet.parseInt(yChunk)%bands) * (1/maximums[PApplet.parseInt(yChunk)%bands]);
       if(normalized < threshold && normalized > -threshold){normalized = 0;}
       if(flipping){
         int multi = -1+(PApplet.parseInt(direction)*2);
         normalized = multi * normalized;
         direction = !direction;
       }
       int loc2 = x + y*width + PApplet.parseInt(normalized*factor);
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

public void keyPressed()
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MinimExample" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
