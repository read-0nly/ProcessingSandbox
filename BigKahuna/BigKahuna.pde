import processing.video.*;

//Initial definition
  Capture img;
  int sleepDelay = 300;

//BadDiv Params
  boolean BadDiv_Switch = true;
  
  //float BadDiv_FactorMin = 0.003;  float BadDiv_FactorMax = 0.005;  float BadDiv_FactorStep = 0.00001; // Green/Pink Deepfry
  //float BadDiv_FactorMin = 1.007;  float BadDiv_FactorMax = 1.010;  float BadDiv_FactorStep = 0.00001; // LightNoise
  float BadDiv_FactorMin = 2.03;  float BadDiv_FactorMax = 2.07;  float BadDiv_FactorStep = 0.0001; // Acid Purples

  float BadDiv_Factor =BadDiv_FactorMin;
  
  float BadDiv_ShiftMin = 0;
  float BadDiv_ShiftMax = 0;
  float BadDiv_RedFactor = 0.9;
  float BadDiv_GreenFactor = 0.9;
  float BadDiv_BlueFactor = 0.9;

//GlitchTrail Params
  boolean  GlitchTrail_Switch = false;
  float GlitchTrail_Decay = 0.999999999999999999;
  int GlitchTrail_Delay = 10;
  int GlitchTrail_Echo = 1;
  int GlitchTrail_RanMin = -4;
  int GlitchTrail_RanMax = 3;
  int GlitchTrail_ExcludeThreshold = 150;
  float GlitchTrail_ExcludeAmount = 0.8;
  int GlitchTrail_Buffer = 0;
  
//GlitchNet Params
  boolean  GlitchNet_Switch = false;
  
//ColorGrav Params
  boolean  ColorGrav_Switch = false;
  float ColorGrav_Target = 120;
  float ColorGrav_Force = 0.15;
  float ColorGrav_ModeMax = 100;

//BadDiv Functions
  void BadDiv_FlipDir(){
    if(BadDiv_Factor>BadDiv_FactorMax){
      BadDiv_FactorStep = -abs(BadDiv_FactorStep);
      BadDiv_Factor =BadDiv_FactorMax;
    }else if (BadDiv_Factor < BadDiv_FactorMin){
      BadDiv_FactorStep = abs(BadDiv_FactorStep);
      BadDiv_Factor = BadDiv_FactorMin;
    }
    BadDiv_Factor = BadDiv_Factor *(1+BadDiv_FactorStep); 
    println(BadDiv_Factor);
  }  
  void BadDiv_SetPix(int x, int y){
    int shift =int(random(-BadDiv_ShiftMin,BadDiv_ShiftMax));
    int loc = x + y*width;
    int loc2 = ((x+shift)%width)+y*width;
    int z = int((GetColorAt(safeLoc(loc))+GetColorAt(safeLoc(loc2)))/BadDiv_Factor);
    pixels[loc] = color(
      (red(z)*BadDiv_RedFactor)+(red(img.pixels[safeLoc(loc)])*(1-BadDiv_RedFactor)),
      (green(z)*BadDiv_GreenFactor)+(green(img.pixels[safeLoc(loc)])*(1-BadDiv_GreenFactor)),
      (blue(z)*BadDiv_BlueFactor)+(blue(img.pixels[safeLoc(loc)])*(1-BadDiv_BlueFactor))
    );
  }

//GlitchTrail Functions
  void GlitchTrail_SetPix(int x, int y){
      int loc = x + y*width;
      loc = loc+GlitchTrail_Buffer;
      float g = green((img.pixels[safeLoc(loc)]))*1;
      float b = blue((img.pixels[safeLoc(loc)]))*1;float r = 0;
      if(true){        
        r= GlitchTrail_HighestRed(img.pixels[safeLoc(loc+GlitchTrail_Delay)], pixels[safeLoc(loc+GlitchTrail_Echo)])*GlitchTrail_Decay; 
        r = r + random(GlitchTrail_RanMin,GlitchTrail_RanMax);
        if(g>GlitchTrail_ExcludeThreshold||b>GlitchTrail_ExcludeThreshold){
         r = r*GlitchTrail_ExcludeAmount; 
        }
      }
        if(r>g&&r>b){
          pixels[(loc-GlitchTrail_Buffer)%(width*height)] =  color(r,g,b);          
        }
        else{
          pixels[(loc-GlitchTrail_Buffer)%(width*height)] =  color(g,g,g);   
        }
  }
  float GlitchTrail_HighestRed(int a, int b){
    if(red(a)>red(b)){
      return red(a);
    }
    else{
      return red(b);
    }
  }
  
//GlitchNet Functions
  void GlitchNet_SetPix(int x, int y){   
    int loc = x + y*width;
    float r = 0;
    if(loc+3<(width*height) && loc > 1){
      r = red(int(img.pixels[safeLoc(loc+5)]*0.1 +
        img.pixels[safeLoc(loc+3)]*0.1 +
        img.pixels[safeLoc(loc+1)]*0.3 +
        img.pixels[loc]*0.5) + pixels[safeLoc(loc-1)]);
    }
    else{
      r = red(int(img.pixels[loc]));
    }
    float g = green(img.pixels[loc]);
    float b = blue(img.pixels[loc]);
    if(r>g&&r>b){
      pixels[loc] =  color(r,g/3,b/2);          
    }
    else{
      pixels[loc] =  color(b,g,b);   
      
    } 
  }
  
//ColorGrav Functions

void ColorGrav_SetPix(int x, int y){
   int loc = x + y*width;
      float g = saturation(img.pixels[safeLoc(loc)]);
      float b = brightness(img.pixels[safeLoc(loc)]);
      float r = 0;
      r= ColorGrav_CircularAverage(hue(img.pixels[safeLoc(loc)]),ColorGrav_Target,ColorGrav_Force,ColorGrav_ModeMax);
      pixels[safeLoc(loc)] =  color(r%ColorGrav_ModeMax,(((2*ColorGrav_ModeMax)+g)/3)%(ColorGrav_ModeMax+1),b%(ColorGrav_ModeMax+1));
       
}
float ColorGrav_CircularAverage(float a, float b, float portionA, float max){
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
  
//Helper Functions
  int GetColorAt(int loc){
   return color(red(img.pixels[safeLoc(loc)]),green(img.pixels[safeLoc(loc)]),blue(img.pixels[safeLoc(loc)])); 
  };
  void setPix(int x, int y){
    int loc = x + y*width;
    pixels[safeLoc(loc)] = GetColorAt(safeLoc(loc));
    
  }
  int safeLoc(int loc){
    return loc%(width*height);
  }

//Core Functions
void setup(){
  //Confirm Color Mode (locks other filters out)
  if(ColorGrav_Switch)
  {
    BadDiv_Switch = false;
    GlitchTrail_Switch = false;
    GlitchNet_Switch = false;
    colorMode(HSB, ColorGrav_ModeMax);
  }
   
  // Set Canvas
  background(0); 
  size(640, 480);
  //Initialize Camera
  String[] cameras = Capture.list();
  img = new Capture(this, cameras[0]);
  img.start();     
}     
void draw() {  
  if (img.available() == true) {
    //init pixels
    img.read();
    loadPixels(); 
    img.loadPixels();
    //BadDiv Flip
    if(BadDiv_Switch){BadDiv_FlipDir();}
    //Pixel Loop
    for( int y = 0; y < height; y++){
      for( int x = 0; x < width; x++){      
        //Apply appropriate filter
        if(BadDiv_Switch){BadDiv_SetPix(x,y);}
        else if(GlitchTrail_Switch){GlitchTrail_SetPix(x,y);}
        else if(GlitchNet_Switch){GlitchNet_SetPix(x,y);}
        else if(ColorGrav_Switch){ColorGrav_SetPix(x,y);}
        else{setPix(x,y);}
      }
    }
    updatePixels();
  }
  //Sleep
  try{java.util.concurrent.TimeUnit.MILLISECONDS.sleep(sleepDelay);}
  catch(Exception e){}
}




 // saveFrame("c:\\temp\\rotDiv2\\rotDiv-"+int(factor*10000)+".png");
