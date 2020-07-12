import processing.video.*;
PImage myMovie;
boolean newFrame;

void settings() {
  myMovie = loadImage("C:\\Temp\\Marilyn\\95699610_576152643295687_5047133309251878912_n.png");
  size(609, 607);
}
void setup(){
  background(0);
}

void draw() {
  loadPixels(); 
  if (true ) {
    myMovie.loadPixels();
    for( int y = 0; y < height; y++){
     for( int x = 0; x < width; x++){
        int loc = x + y*width;
        float r = 0;
        if(loc+3<(width*height) && loc > 1){
         r = red(int(myMovie.pixels[loc+3]*0.1 +
          myMovie.pixels[loc+2]*0.1 +
          myMovie.pixels[loc+1]*0.3 +
          myMovie.pixels[loc]*0.5) + pixels[loc-1]);
        }
        else{
           r = red(int(myMovie.pixels[loc]));
        }
        float g = green(myMovie.pixels[loc]);
        float b = blue(myMovie.pixels[loc]);
        
        // Image Processing would go here
        // If we were to change the RGB values, we would do it here, 
        // before setting the pixel in the display window.
        
        // Set the display pixel to the image pixel
        if(r>g&&r>b){
          pixels[loc] =  color(r,g,b);          
        }
        else{
          pixels[loc] =  color(b,g,b);   
          
        }
     } 
    }
  }
  updatePixels();
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  newFrame = true;
}
