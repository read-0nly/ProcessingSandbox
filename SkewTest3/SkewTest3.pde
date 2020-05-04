PImage img;

  float buffer = 0;
  float bufferStrength= 1;
  float bufferStep = 1;
  float bufferMax = 10;
  int spaceMax = 10000000;
  float spacer = spaceMax-1;
  float spaceStep = 0.9;
  boolean buffDir = true;
  boolean spaceDir = false;
  int delay = 0;
void settings(){
 img = loadImage("C:\\Users\\read-0nly\\Downloads\\94482676_10158124428327068_5007892228882825216_o.jpg");
 img.resize(264,264);
 size(img.width, img.height);
 spacer = width;
}
void setup(){
  img.loadPixels();   
}

void draw(){
  loadPixels(); //<>//
    delay++;
  
  
  float bufferThreshold = bufferStrength;   
  buffer = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int locI = x + y*width;
      int loc = x + y*width;
      if(delay>10){
        if(buffDir){
          bufferStrength+=bufferStep;
        }
        else{
          bufferStrength-=bufferStep;
        }
        if(bufferStrength >=bufferMax || bufferStrength <=1){
          buffDir = !buffDir;
        }
      }
      if(loc%int(spacer)==0 && int(loc/spacer) > 0){
        buffer+=random((0-bufferThreshold),bufferThreshold);
      }       
  
      locI = (locI%img.pixels.length);
      float r = red(img.pixels[int(abs(locI+buffer/1)%img.pixels.length)]);
      float g = green(img.pixels[int(abs(locI+(buffer/1.8))%img.pixels.length)]);
      float b = blue(img.pixels[int(abs(locI+buffer/1.2)%img.pixels.length)]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r,g,b);
    }
  } 
  updatePixels();
  saveFrame("c:\\temp\\fbVid-###.png");
}
