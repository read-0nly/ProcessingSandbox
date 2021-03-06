import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import javax.swing.JOptionPane; 
import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BigKahuna extends PApplet {




//Mode Strings
//BadDiv
/*
100;1000;0.05;0;0;0.7;true; Pink and Gold
0.003;0.005;0.00001;0;0;0;true; LightNoise
1.007;1.010;0.0001;180;-180;0.5;false; GhostTwin
2.03;2.07;0.0001;0;0;0.5;true; Acid Purples
*/
//GlitchTrail
/*
0.999999999999999999;10;1;-4;3;150;0.8;0;  //BigRed
0.99;500;1;-34;3;100;0.8;0; //SmallEcho
*/
//GlitchNet
//ColorGrav



//Initial definition
  Capture img;
  int sleepDelay = 100;
  boolean freezeBadDiv = false;
  
//BadDiv Params
  boolean BadDiv_Switch = false;
  float BadDiv_FactorMin = 1.005f;  float BadDiv_FactorMax = 1.015f;  float BadDiv_FactorStep = 0.00005f;float BadDiv_ShiftMin = -2;  float BadDiv_ShiftMax = 9; float BadDiv_ColorFactor = 0.6f; boolean BadDiv_RanShift=true;// Green/Pink Deepfry
  float BadDiv_Factor =BadDiv_FactorMin;  
  float BadDiv_RedFactor = (BadDiv_ColorFactor<0.01f? 0.7f : BadDiv_ColorFactor);
  float BadDiv_GreenFactor = (BadDiv_ColorFactor<0.01f? 0.7f : BadDiv_ColorFactor);
  float BadDiv_BlueFactor = (BadDiv_ColorFactor<0.01f? 0.7f : BadDiv_ColorFactor);

//GlitchTrail Params
  boolean  GlitchTrail_Switch = false;
  float GlitchTrail_Decay = 0.999999999999999999f;
  int GlitchTrail_Delay = 10;
  int GlitchTrail_Echo = 1;
  int GlitchTrail_RanMin = -4;
  int GlitchTrail_RanMax = 3;
  int GlitchTrail_ExcludeThreshold = 150;
  float GlitchTrail_ExcludeAmount = 0.8f;
  int GlitchTrail_Buffer = 0;
  
//GlitchNet Params
  boolean  GlitchNet_Switch = false;
  
//ColorGrav Params
  boolean  ColorGrav_Switch = false;
  float ColorGrav_Target = 120;
  float ColorGrav_Force = 0.15f;
  float ColorGrav_ModeMax = 100;

//BadDiv Functions
  public void BadDiv_FlipDir(){
    if(BadDiv_Factor>BadDiv_FactorMax){
      BadDiv_FactorStep = -abs(BadDiv_FactorStep);
      BadDiv_Factor =BadDiv_FactorMax;
    }else if (BadDiv_Factor < BadDiv_FactorMin){
      BadDiv_FactorStep = abs(BadDiv_FactorStep);
      BadDiv_Factor = BadDiv_FactorMin;
    }
    if(!freezeBadDiv){
      BadDiv_Factor = BadDiv_Factor *(1+BadDiv_FactorStep);
    }
    println(BadDiv_Factor);
  }  
  public void BadDiv_SetPix(int x, int y){
    
    int shift =0;
    if(!BadDiv_RanShift){
      if(PApplet.parseBoolean(PApplet.parseInt(random(0,2)))){
       shift= PApplet.parseInt(-BadDiv_ShiftMin);
      }else{        
       shift= PApplet.parseInt(BadDiv_ShiftMax);
      }
    }else{
      shift =PApplet.parseInt(random(-BadDiv_ShiftMin,BadDiv_ShiftMax));
    }
    int loc = x + y*width;
    int loc2 = ((x+shift)%width)+y*width;
    int z = PApplet.parseInt((GetColorAt(safeLoc(loc))+GetColorAt(safeLoc(loc2)))/BadDiv_Factor);
    pixels[loc] = color(
      (red(z)*BadDiv_RedFactor)+(red(img.pixels[safeLoc(loc)])*(1-BadDiv_RedFactor)),
      (green(z)*BadDiv_GreenFactor)+(green(img.pixels[safeLoc(loc)])*(1-BadDiv_GreenFactor)),
      (blue(z)*BadDiv_BlueFactor)+(blue(img.pixels[safeLoc(loc)])*(1-BadDiv_BlueFactor))
    );
  }

//GlitchTrail Functions
  public void GlitchTrail_SetPix(int x, int y){
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
  public float GlitchTrail_HighestRed(int a, int b){
    if(red(a)>red(b)){
      return red(a);
    }
    else{
      return red(b);
    }
  }
  
//GlitchNet Functions
  public void GlitchNet_SetPix(int x, int y){   
    int loc = x + y*width;
    float r = 0;
    if(loc+3<(width*height) && loc > 1){
      r = red(PApplet.parseInt(img.pixels[safeLoc(loc+5)]*0.1f +
        img.pixels[safeLoc(loc+3)]*0.1f +
        img.pixels[safeLoc(loc+1)]*0.3f +
        img.pixels[loc]*0.5f) + pixels[safeLoc(loc-1)]);
    }
    else{
      r = red(PApplet.parseInt(img.pixels[loc]));
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

public void ColorGrav_SetPix(int x, int y){
   int loc = x + y*width;
      float g = saturation(img.pixels[safeLoc(loc)]);
      float b = brightness(img.pixels[safeLoc(loc)]);
      float r = 0;
      r= ColorGrav_CircularAverage(hue(img.pixels[safeLoc(loc)]),ColorGrav_Target,ColorGrav_Force,ColorGrav_ModeMax);
      pixels[safeLoc(loc)] =  color(r%ColorGrav_ModeMax,(((2*ColorGrav_ModeMax)+g)/3)%(ColorGrav_ModeMax+1),b%(ColorGrav_ModeMax+1));
       
}
public float ColorGrav_CircularAverage(float a, float b, float portionA, float max){
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
  public int GetColorAt(int loc){
   return color(red(img.pixels[safeLoc(loc)]),green(img.pixels[safeLoc(loc)]),blue(img.pixels[safeLoc(loc)])); 
  };
  public void setPix(int x, int y){
    int loc = x + y*width;
    pixels[safeLoc(loc)] = GetColorAt(safeLoc(loc));
    
  }
  public int safeLoc(int loc){
    if(loc<0){
     loc = (width*height)+loc;
    }
    return loc%(width*height);
  }

//Core Functions
public void setup(){
  // Set Canvas
  background(0); 
  
  //Initialize Camera
  String[] cameras = Capture.list();
  img = new Capture(this, cameras[0]);
  img.start();     
}     
public void draw() {  
  
  if (img.available() == true) {
    //init pixels
    
    if ((keyPressed == true)) {
      switch(key){ //<>//
        case 'q':{
          BadDiv_Switch=true;
          key = '~'; keyPressed = false;
          break;
        }
        case 'a':{
          BadDiv_Switch=false;
          key = '~'; keyPressed = false;
          break;
        }
        case 'w':{
          GlitchTrail_Switch=true;
          key = '~'; keyPressed = false;
          break;
        }
        case 's':{
          GlitchTrail_Switch=false;
          key = '~'; keyPressed = false;
          break;
        }
        case 'e':{
          GlitchNet_Switch=true;
          key = '~'; keyPressed = false;
          break;
        }
        case 'd':{
          GlitchNet_Switch=false;
          key = '~'; keyPressed = false;
          break;
        }
        case 'r':{
          ColorGrav_Switch=true;
          BadDiv_Switch = false;
          GlitchTrail_Switch = false;
          GlitchNet_Switch = false;
          colorMode(HSB, ColorGrav_ModeMax);
          key = '~'; keyPressed = false;
          break;
        }
        case 'f':{
          ColorGrav_Switch=false;
          BadDiv_Switch = false;
          GlitchTrail_Switch = false;
          GlitchNet_Switch = false;
          colorMode(RGB, 255);  
          key = '~'; keyPressed = false;
          break;
        }
        case 'z':{
          getModeString();
          key = '~'; keyPressed = false;
          break;
        }
        case 'Q':{
          freezeBadDiv=true;
          key = '~'; keyPressed = false;
          break;
        }
        case 'A':{
          freezeBadDiv=false;
          key = '~'; keyPressed = false;
          break;
        }
        case '~':{
          println("looping");
          key = '~'; keyPressed = false;          
          break;
        } //<>//
      }
    }
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

public void getModeString(){
  
  /*if(BadDiv_Switch){BadDiv_SetPix(x,y);}
  else if(GlitchTrail_Switch){GlitchTrail_SetPix(x,y);}
  else if(GlitchNet_Switch){GlitchNet_SetPix(x,y);}
  else if(ColorGrav_Switch){ColorGrav_SetPix(x,y);}*/
  String[] possibilities = {"BadDiv", "GlitchTrail", "GlitchNet","ColorGrav"};
  String s = (String)JOptionPane.showInputDialog(
    frame,
    "Pick the mode to configure",
    "Mode Config String",
    JOptionPane.PLAIN_MESSAGE,
    null,
    possibilities,
    "BadDiv");
  switch(s){
   case "BadDiv":{
   String s2 = (String)JOptionPane.showInputDialog(
      frame,
      "Enter values seperated by semi-colon:\n"+
      "BadDiv_FactorMin;BadDiv_FactorMax;BadDiv_FactorStep;BadDiv_ShiftMin;BadDiv_ShiftMax;BadDiv_ColorFactor;BadDiv_RanShift;",
      "Mode Config String",
      JOptionPane.PLAIN_MESSAGE,
      null,
      null,
      "BadDiv");
      String[] s2Arr = s2.split(";");
      BadDiv_FactorMin = PApplet.parseFloat(s2Arr[0]);
      BadDiv_FactorMax = PApplet.parseFloat(s2Arr[1]);
      BadDiv_FactorStep = PApplet.parseFloat(s2Arr[2]);
      BadDiv_ShiftMin = PApplet.parseFloat(s2Arr[3]);
      BadDiv_ShiftMax = PApplet.parseFloat(s2Arr[4]);
      BadDiv_ColorFactor = PApplet.parseFloat(s2Arr[5]); 
      BadDiv_RedFactor = (BadDiv_ColorFactor<0.01f? 0.7f : BadDiv_ColorFactor);
      BadDiv_GreenFactor = (BadDiv_ColorFactor<0.01f? 0.7f : BadDiv_ColorFactor);
      BadDiv_BlueFactor = (BadDiv_ColorFactor<0.01f? 0.7f : BadDiv_ColorFactor);
      BadDiv_RanShift = (s2Arr[6]=="true"?true:false);
    break; 
   }
   case "GlitchTrail":{
   String s2 = (String)JOptionPane.showInputDialog(
      frame,
      "Enter values seperated by semi-colon:\n"+
      "GlitchTrail_Decay;GlitchTrail_Delay;GlitchTrail_Echo;GlitchTrail_RanMin;GlitchTrail_RanMax;GlitchTrail_ExcludeThreshold;GlitchTrail_ExcludeAmount;GlitchTrail_Buffer",
      "Mode Config String",
      JOptionPane.PLAIN_MESSAGE,
      null,
      null,
      "BadDiv");
      String[] s2Arr = s2.split(";");     
    GlitchTrail_Decay = PApplet.parseFloat(s2Arr[0]);
    GlitchTrail_Delay = PApplet.parseInt(PApplet.parseFloat(s2Arr[1]));
    GlitchTrail_Echo = PApplet.parseInt(PApplet.parseFloat(s2Arr[2]));
    GlitchTrail_RanMin = PApplet.parseInt(PApplet.parseFloat(s2Arr[3]));
    GlitchTrail_RanMax = PApplet.parseInt(PApplet.parseFloat(s2Arr[4]));
    GlitchTrail_ExcludeThreshold = PApplet.parseInt(PApplet.parseFloat(s2Arr[5]));
    GlitchTrail_ExcludeAmount = PApplet.parseFloat(s2Arr[6]);
    GlitchTrail_Buffer = PApplet.parseInt(PApplet.parseFloat(s2Arr[7]));
    break; 
   }
   case "GlitchNet":{
    break; 
   }
   case "ColorGrav":{
    break; 
   }
    
  }
}


 // saveFrame("c:\\temp\\rotDiv2\\rotDiv-"+int(factor*10000)+".png");
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BigKahuna" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
