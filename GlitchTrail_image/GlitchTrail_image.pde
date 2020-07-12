import processing.video.*;
PImage myMovie;
int drag = 10;
float decay = 0.999999999999999999;
int delay = 10;
int echo = 1;
int ranMin = -4;
int ranMax = 3;
int excludeThreshold = 150;
float excludeAmount = 0.8;
int buffer = 0;

void settings() {
  myMovie = loadImage("C:\\Temp\\Marilyn\\95699610_576152643295687_5047133309251878912_n.png");
  size(609, 607);
}
void setup(){
  background(0);
}

void draw() {
  loadPixels(); 
  if (true) {
  myMovie.loadPixels();
  for( int y = 0; y < height; y++){
   for( int x = 0; x < width; x++){
      int loc = x + y*width;
      /*if(x == 0&&y>200&&y<500){
        buffer = buffer + 1;
      }*/
      loc = loc+buffer;
      float g = green((myMovie.pixels[loc%(width*height)]))*1;
      float b = blue((myMovie.pixels[loc%(width*height)]))*1;
      float r = 0;
      if(true){
        
        r= highestRed(myMovie.pixels[(loc+delay)%(width*height)], pixels[(loc+echo) %(width*height)])*decay; 
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
        if(r>g&&r>b){
          pixels[(loc-buffer)%(width*height)] =  color(r,g,r);          
        }
        else{
          pixels[(loc-buffer)%(width*height)] =  color(g,g,g);   
          
        }
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
