
import processing.video.*;
Capture myMovie;

float factorMin = 2.03;
float factorMax = 2.07;
float factor =factorMin;
//2.027, 2.031-2.0
float factorStep = 0.0001;
//float stepDecay =1; 
boolean factorDir = true;   

float redFactor = 0.9;
float greenFactor = 0.9;
float blueFactor = 0.9;
void settings() {
  //myMovie = loadImage("D:\\Media\\Pictures\\memes\\Resources\\Anime - Honda-San\\5bfc7ee5d9124.bmp");
   size(640, 480);
}
void setup(){
  background(0); 

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    myMovie = new Capture(this, cameras[0]);
    myMovie.start();     
  }     
}
void draw() {
  
  if (myMovie.available() == true) {
    myMovie.read();
  loadPixels(); 
  if(factor>factorMax){
    factorDir = false;
    factorStep = -abs(factorStep);
    factor =factorMax;
  }else if (factor < factorMin){
     factorDir = true;
    factorStep = abs(factorStep);
    factor = factorMin;
  }
      factor = factor *(1+factorStep);
  myMovie.loadPixels();
  for( int y = 0; y < height; y++){
   int shift = 0;//50 + int(random(-10,10));
   for( int x = 0; x < width; x++){
      int loc = x + y*width;
      int loc2 = ((x+shift)%width)+y*width;
      if(y<0){
      pixels[loc] = avgColors(loc,loc2);
      }
      else{
        int z = int((getColorAt(loc)+getColorAt(loc2))/factor);
        pixels[loc] = color(
          (red(z)*redFactor)+(red(getColorAt(loc))*(1-redFactor)),
          (green(z)*greenFactor)+(green(getColorAt(loc))*(1-greenFactor)),
          (blue(z)*blueFactor)+(blue(getColorAt(loc))*(1-blueFactor))
          );
          
      }
   }
 }
 try{
  java.util.concurrent.TimeUnit.MILLISECONDS.sleep(100);
 }
 catch(Exception e){}
  println(factor);
  }
  updatePixels();
 // saveFrame("c:\\temp\\rotDiv2\\rotDiv-"+int(factor*10000)+".png");
}

int getColorAt(int loc){
 return color(red(myMovie.pixels[loc]),green(myMovie.pixels[loc]),blue(myMovie.pixels[loc])); 
};
int avgColors(int loc, int loc2){
 return color(
   int(red(myMovie.pixels[loc])+red(myMovie.pixels[loc2])/2),
   int(green(myMovie.pixels[loc])+green(myMovie.pixels[loc2])/2),
   int(blue(myMovie.pixels[loc])+blue(myMovie.pixels[loc2])/2)
 ); 
};
