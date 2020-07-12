
PImage myMovie;
void settings() {
  myMovie = loadImage("C:\\Temp\\Marilyn\\95699610_576152643295687_5047133309251878912_n.png");
  size(609, 607);
}
void setup(){
  background(0);
}
void draw() {
  loadPixels(); 
  myMovie.loadPixels();
  for( int y = 0; y < height; y++){
   int shift = 50 + int(random(-10,10));
   for( int x = 0; x < width; x++){
      int loc = x + y*width;
      int loc2 = ((x+shift)%width)+y*width;
      if(y<300){
      pixels[loc] = avgColors(loc,loc2);
      }
      else{
        pixels[loc] = (getColorAt(loc)+getColorAt(loc2))/2;
      }
   }
 }
  updatePixels();
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
