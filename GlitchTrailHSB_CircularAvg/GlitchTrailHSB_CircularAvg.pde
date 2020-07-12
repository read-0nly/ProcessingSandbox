import processing.video.*;
Movie myMovie;
int drag = 10;
float decay = 1;
int delay = 0;
int echo = 0;
int ranMin = 0;
int ranMax = 0;
int excludeThreshold = 255;
float excludeAmount = 1;

boolean decayHue = true;
boolean decayBright = false;
boolean decaySat = false;

void settings() {
  myMovie = new Movie(this, "D:\\Media\\Videos\\4e6yWVM.mp4");
  size(720, 720);
}
void setup(){
  background(0);
colorMode(HSB, 255);
  myMovie.loop(); 
}

void draw() {
  
  float a = circularAverage(100,60,0.5,255);//float a, float b, float portionA, float max
  a = circularAverage(0,155,0.5,255);//float a, float b, float portionA, float max
  a = circularAverage(250,5,0.5,255);//float a, float b, float portionA, float max
  a = circularAverage(100,60,0.5,255);
  a=a+0;//float a, float b, float portionA, float max
  loadPixels(); 
  if (myMovie.available()) {
  myMovie.read();
  myMovie.loadPixels();
  for( int y = 0; y < myMovie.height; y++){
   for( int x = 0; x < myMovie.width; x++){
      int loc = x + y*width;
      float g = saturation(myMovie.pixels[loc]);
      float b = brightness(myMovie.pixels[loc]);
      float r = 0;
      r= circularAverage(hue(myMovie.pixels[loc]),150,0.4,255);
      
      //r = (r>254?0:r);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r%255,g%256,b%256);
      
   } 
  }
  }
  updatePixels();
}

float closestSat(int a, int b, int mid){
  if(saturation(a)>saturation(b)){
    return saturation(a);
  }
  else{
    return saturation(b);
  }
}
float closestBright(int a, int b, int mid){
  if(saturation(a)>saturation(b)){
    return saturation(a);
  }
  else{
    return saturation(b);
  }
}
float closestHue(int a, int b, int mid){
  if(abs(hue(a)-mid)<abs(hue(b)-mid)){
    return hue(a);
  }
  else{
    return hue(b);
  }
}

float circularAverage(float a, float b, float portionA, float max){
  float a2 = a+max;
  float b2 = b+max;
  float portionB = 1-portionA;
  if(a<b && b<a2){
    if(b-a<a2-b){
      return (a*portionA+b*portionB)%(max);
    }
    else{
      return (a2*portionA+b*portionB)%(max);
    }
  }
  else{if(b2-a<a2-b2){
      return (a*portionA+b2*portionB)%(max);
    }
    else{
      return (a2*portionA+b2*portionB)%(max);
    }    
  }
}
// Called every time a new frame is available to read
void movieEvent(Movie m) {
}
