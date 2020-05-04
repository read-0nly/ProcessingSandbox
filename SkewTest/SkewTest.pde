PImage img;

  float buffer = 0;
  float bufferStrength= 1;
  float bufferStep = 1;
  int spaceMax = 10000000;
  float spacer = spaceMax-1;
  float spaceStep = 0.9;
  boolean buffDir = true;
  boolean spaceDir = false;
  int delay = 0;
void settings(){
 img = loadImage("https://solarsystem.nasa.gov/system/resources/detail_files/697_nh-pluto-charon-v2-10-1-15_1600.jpg");
 img.resize(1080,1080);
 size(img.width, img.height);
}
void setup(){
  img.loadPixels();   
}

void draw(){
  loadPixels();
  if(delay>10){
    if(buffDir){
      bufferStrength+=bufferStep;
    }
    else{
      bufferStrength-=bufferStep;
    }
    if(spaceDir){
     spacer= spacer/spaceStep; 
    }else{
     spacer=spacer*spaceStep;
    };
    if(spacer >=spaceMax || spacer < 1.5){
      spaceDir = !spaceDir; //<>//
    }
    if(bufferStrength >=50 || bufferStrength <=1){
      buffDir = !buffDir; //<>//
    }
  }
  else{
    delay++;
  }
  
  float bufferThreshold = bufferStrength;   
  buffer = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int locI = x + y*width;
      int loc = x + y*width;
      if(loc%int(spacer)==0 && int(loc/spacer) > 0){
        buffer+=random((0-bufferThreshold),bufferThreshold);
      }       
  
      locI = (locI%img.pixels.length);
      float r = red(img.pixels[int(abs(locI+buffer)%img.pixels.length)]);
      float g = green(img.pixels[int(abs(locI-(buffer/3))%img.pixels.length)]);
      float b = blue(img.pixels[int(abs(locI+buffer/1)%img.pixels.length)]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r,g,b);
    }
  } 
  updatePixels();
}
