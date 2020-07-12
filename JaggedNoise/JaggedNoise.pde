
PImage myMovie;
float tremorStrength = 5;
float tremorTilt = -0.2;
float tremorPaint = 0.6;

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
   int shift = 0;
  for( int y = 0; y < height; y++){
    shift=shift+int(random(-tremorStrength+tremorTilt,tremorStrength));
   for( int x = 0; x < width; x++){
      int loc = x + y*width;
      int loc2 = ((x+shift)%width)+y*width;
      pixels[loc] = avgColors(loc,loc2);
   }
 }
  updatePixels();
}

int getColorAt(int loc){
 return color(red(myMovie.pixels[loc]),green(myMovie.pixels[loc]),blue(myMovie.pixels[loc])); 
};
int avgColors(int loc, int loc2){
 loc = abs(loc);
 loc2 = abs(loc2);
 return color(
   (
     (red(myMovie.pixels[loc%(myMovie.width*myMovie.height)])*(1-tremorPaint))+
     (red(myMovie.pixels[loc2%(myMovie.width*myMovie.height)])*tremorPaint)
   ),
   (
     (green(myMovie.pixels[loc%(myMovie.width*myMovie.height)])*(1-tremorPaint))+
     (green(myMovie.pixels[loc2%(myMovie.width*myMovie.height)])*tremorPaint)
   ),
   (
     (blue(myMovie.pixels[loc%(myMovie.width*myMovie.height)])*(1-tremorPaint))+
     (blue(myMovie.pixels[loc2%(myMovie.width*myMovie.height)])*tremorPaint)
   )
 ); 
};
