import processing.video.*;
Movie myMovie;
int drag = 10;
float decay = 0.9999;
int delay = 10;
int echo = 10;
int ranMin = -6;
int ranMax = 2;
int excludeThreshold = 255;
float excludeAmount = 1.1;

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
  loadPixels(); 
  if (myMovie.available()) {
  myMovie.read();
  myMovie.loadPixels();
  for( int y = 0; y < myMovie.height; y++){
   for( int x = 0; x < myMovie.width; x++){
      int loc = x + y*width;
      float g = green(myMovie.pixels[loc])*1.5;
      float b = blue(myMovie.pixels[loc])*1.5;
      float r = 0;
      if(x<width-drag
        && (loc+delay+1 < (myMovie.width*myMovie.height))
        && (loc+echo+1 < (myMovie.width*myMovie.height))
        ){
        
        r= highestRed(myMovie.pixels[loc+delay], pixels[loc+echo])*decay; 
        r = r + random(ranMin,ranMax);
        if(g>excludeThreshold||b>excludeThreshold){
         r = r*excludeAmount; 
        }
      }
      //r = (r>254?0:r);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r,g,b);
   } 
  }
  }
  updatePixels();
}

float highestRed(int a, int b){
  if(red(a)>red(b)){
    return red(a);
  }
  else{
    return red(b);
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
}
