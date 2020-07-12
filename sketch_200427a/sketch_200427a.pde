PImage img;

void settings(){
 img = loadImage("C:\\Users\\read-0nly\\Pictures\\XdzF9QR.jpg");
 size(img.width,img.height);
}

void draw(){
 
  loadPixels(); 
  img.loadPixels(); 
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int loc = x + y*width;
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r,g,b);          
    }
  } 
}
