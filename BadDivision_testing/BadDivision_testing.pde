
PImage myMovie;
float factor =0.1;
float factorStep = 0.001;
float resolution = 1000;
float stepDecay =0.999999999995; 
float shiftBump = 0;
float shiftThresh = 0;
float shiftStrength = 0;
boolean factorDir = true; 
float lerpFactor = 1;
float redFactor = 0.3;
float greenFactor = 0.7;
float blueFactor = 0.3;
void settings() {
  myMovie = loadImage("C:\\Temp\\100820000_1650965365055917_8497915192561106944_n.png");
  size(myMovie.width, myMovie.height);
}
void setup(){
  background(0);
}
void draw() {
  loadPixels(); 
  stepDecay = stepDecay * stepDecay;
  if(factor>3000){
    factorDir = false;
  }else if (factor < 0.001){
     factorDir = true;
  }
      factor = factor+factorStep;
  myMovie.loadPixels();
      float c = (int(factor*resolution)/resolution);
  for( int y = 0; y < height; y++){
   int shift = int(shiftBump + int(random(-shiftThresh,shiftThresh)));
   for( int x = 0; x < width; x++){
      int loc = x + y*width;
      int loc2 = ((x+shift)%width)+y*width;
      int z = int((getColorAt(loc)+(getColorAt(loc2)*shiftStrength))/c);
      pixels[loc] = lerpColor(getColorAt(loc),z,lerpFactor);
   }
 }
 try{
  //java.util.concurrent.TimeUnit.SECONDS.sleep(1);
 }
 catch(Exception e){}
  println( c );
  updatePixels();
  //saveFrame("c:\\temp\\rotDiv-arm3\\rotDiv-butt-####.png");
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
