import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SkewTest extends PApplet {

PImage img;

public void settings(){
 img = loadImage("https://i.redd.it/hb2crp82d6v41.jpg");
 img.resize(500,500);
 size(img.width, img.height);
}
public void setup(){
  img.loadPixels();   
}

public void draw(){
  loadPixels(); 
  int buffer = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int loc = x + y*width;
      if(loc%900==0){
        buffer+=random(-1,1.2f);
      }
      if (buffer+loc < 0){
       buffer =0; 
      }
      int locI = x + y*width+buffer;
      locI = (locI%img.pixels.length);
      float r = red(img.pixels[locI]);
      float g = green(img.pixels[locI]);
      float b = blue(img.pixels[locI]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r,g,b);          
    }
  } 
  updatePixels();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SkewTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
