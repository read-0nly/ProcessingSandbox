//
import javax.swing.JOptionPane; 
import processing.video.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

PImage Picture;
Capture Camera;
Movie Video;
PictureCollection Slideshow;
String Mode = "None";
Filter currentFilter;
int errorcount = 0;
void settings() {
}
void setup()
{
  background(0);
  //myMovie.loadPixels();
  frame.setResizable(true);
}
void draw()
{
  stroke(255);
  background(0);
  try{
    loadPixels();
  }
  catch(Exception e){
    println("Oops"+errorcount);
    errorcount++;
  }
  int[] currentPixels = new int[0];
  int currentWidth = 0;
  switch(Mode){
   case "Image":{
    Picture.loadPixels();
    currentPixels = Picture.pixels;
    currentWidth = Picture.width;
    break;
   }
   case "Movie":{
    if (Video.available()) {
      Video.read();
      Video.loadPixels();
    }
    currentPixels = Video.pixels;
    currentWidth = Video.width;
   }
  }
  if(currentFilter!=null){
    if(currentPixels != null && currentPixels.length > 0){
     currentPixels = currentFilter.draw(currentPixels, currentWidth); 
    }
  }
  if(currentPixels != null && currentPixels.length > 0){
      int currentHeight = (currentPixels.length/currentWidth);
      int heightOffset = (height - currentHeight)/2;
      int widthOffset = (width - currentWidth)/2;
      for( int y = 0; y < height; y++){
        for( int x = 0; x < width; x++){
          int x1 = (widthOffset>0?x+widthOffset:x);
          int x2 = (widthOffset<0?x-widthOffset:x);
          int y1 = (heightOffset>0?y+heightOffset:y);
          int y2 = (heightOffset<0?y-heightOffset:y);
          int loc1 =  -1;
          int loc2 = -1;
          if(x1>=0 && y1>=0 &&x1<width &&y1<height){ 
            loc1=x1 + y1*width;
          }
          if(x2>=0 && y2>=0 &&x2<currentWidth &&y2<currentHeight){ 
            loc2=x2 + y2*currentWidth;
          }
          if(loc1>0&&loc2>0){
            pixels[loc1%(pixels.length-1)]=currentPixels[loc2%(currentPixels.length-1)];
          }
        }
      }
    }
  
  else{
  }
  try{
    updatePixels();
  }
  catch(Exception e){
    println("00ps"+errorcount);
    errorcount++;
  }
}
void keyPressed(){
  switch(key){
    //Keys reserved for filter switching
     case '1':{
       currentFilter = new ColorshiftVisualizer();
       currentFilter.init(this);
           
       break;
     }
     case '2':{
       currentFilter = new LegacyKahuna();
       currentFilter.init(this);
           
       break;
     }
     case '3':{
       currentFilter = null;
           
       break;
     }
     case '4':{
       currentFilter = null;
           
       break;
     }
     case '5':{
       currentFilter = null;
           
       break;
     }
     case '6':{
       currentFilter = null;
           
       break;
     }
     case '7':{
       currentFilter = null;
           
       break;
     }
     case '8':{
       currentFilter = null;
           
       break;
     }
     case '9':{
       currentFilter = null;
           
       break;
     }
     case '0':{
       currentFilter = null;
           
       break;
     }
     //Keys reserved for mode switching 
     case 'q'|'Q':{
       Mode = "Image";
       Picture = loadImage(JOptionPane.showInputDialog("Enter File Path").replace("\"",""));
       Picture.loadPixels();
           
       break;
     }
     case 'w'|'W':{
       Mode = "Slideshow";
           
       break;
     }
     case 'e'|'E':{
       Mode = "Movie";
           
       Video = new Movie(this, JOptionPane.showInputDialog("Enter File Path").replace("\"",""));
       Video.loop(); 
       
       break;
     }
     case 'r'|'R':{
       Mode = "Webcam";
           
       break;
     }
     case 't'|'T':{
       Mode = "None";
           
       break;
     }
     //Keys reserved for media control
     
     case 'u'|'U':{ //play/pause
       break;
     }
     case 'i'|'I':{ //stop/go to beginning
       break;
     }
     case 'o'|'O':{ //Next Image-go to time
       break;
     }
     case 'p'|'P':{ //center
       break;
     }
     case '['|'{':{ //fit
       break;
     }
     case ']'|'}':{ //fill
       break;
     }
   default:{
     if(currentFilter!=null){currentFilter.handleKey(key);}
   }
  }
}

abstract class Filter {
 public abstract void init(float[] parameters, int[] pix, BigKahunaPart2 parent); //sets up the filter with defined parameters and pixels
 public abstract void init(int[] pix, BigKahunaPart2 parent); //sets up the filter with default parameters and included pixels
 public abstract void init(BigKahunaPart2 parent); //sets up the filter with default parameters and included pixels
 public abstract void configure();  //runs the condfiguration flow, usually a series of prompts
 public abstract void handleKey(char k); //handles keypresses - 0-9 are reserved for switching the current active filter
 public abstract void setPixels(int[] pix); //updates the internal pixels - mostly for video and webcam capture
 public abstract int[] draw(int[] pix, int curWidth); //
 public abstract int[] draw(int curWidth); //
}

class ColorshiftVisualizer extends Filter{
 AudioPlayer[] songs = new AudioPlayer[0];
 int[] internalPixels;
Minim minim;
AudioPlayer player; 
FFT fft;
float[] maximums;
float maximum;
int lastPos =0;
boolean direction = true;
boolean flipping = true;
int bands = 0;
float factor = 30;
float bandWidth = 2.5;
float threshold = 0.3;
boolean fftTransform = false;
boolean shiftRed = true;
boolean shiftBlue = true;
boolean shiftGreen = false;

 
 public void init(float[] parameters, int[] pix, BigKahunaPart2 parent){
   
 }; //sets up the filter with defined parameters and pixels
 public void init(int[] pix, BigKahunaPart2 parent){
   internalPixels = pix;
   init(parent);
 }; //sets up the filter with default parameters and included pixels
 public void init(BigKahunaPart2 parent){
   minim = new Minim(parent);
   configure();
 }; //sets up the filter with default parameters and included pixels
 public void configure(){
   String mp3String = JOptionPane.showInputDialog("Enter a semi-colon delimited list of songs");
   String[] mp3Paths = mp3String.replace("\"","").split(";");
   songs = new AudioPlayer[mp3Paths.length];
   for(int i = 0; i < mp3Paths.length; i++){
      songs[i]=minim.loadFile(mp3Paths[i]);
   }
   player = songs[0];
   
   String shouldFlip = JOptionPane.showInputDialog("Should this be doubling? y/n");
   
    if(shouldFlip =="y" || shouldFlip =="Y"){
      
    }
   String shouldFactor = JOptionPane.showInputDialog("Enter the desired factor");
   factor = parseFloat(shouldFactor);
   String shouldBandwidth = JOptionPane.showInputDialog("Enter the desired bandwidth");
   
   bandWidth = parseFloat(shouldBandwidth);
   String shouldThreshold = JOptionPane.showInputDialog("Enter the desired threshold");
   
   threshold = parseFloat(shouldThreshold);
   String shouldFFT = JOptionPane.showInputDialog("Should this FFT? y/n");
    if(shouldFFT =="y" || shouldFFT =="Y"){
      
    }
   String shouldRed = JOptionPane.showInputDialog("Should Red? y/n");
    if(shouldRed =="y" || shouldRed =="Y"){
      
    }
   String shouldGreen = JOptionPane.showInputDialog("Should Green? y/n");
    if(shouldGreen =="y" || shouldGreen =="Y"){
      
    }
   String shouldBlue = JOptionPane.showInputDialog("Should Blue? y/n");
    if(shouldBlue =="y" || shouldBlue =="Y"){
      
    }
    fft = new FFT( player.bufferSize(), player.sampleRate() );
    maximums = new float[player.bufferSize()];
    bands = player.bufferSize();
 };  //runs the condfiguration flow, usually a series of prompts
 public void handleKey(char k){
  switch(k){
    case ' ': {
      if ( player.isPlaying() )
      {
        player.pause();
      }
      // if the player is at the end of the file,
      // we have to rewind it before telling it to play again
      else if ( player.position() == player.length() )
      {
        player.rewind();
        player.play();
      }
      else
      {
        player.play();
      }
           
      break;
    }
  }
 }; //handles keypresses - 0-9 are reserved for switching the current active filter
 
 
 public void setPixels(int[] pix){
   internalPixels = pix;
 }; //updates the internal pixels - mostly for video and webcam capture
 public int[] draw(int[] pix, int curWidth){
      int currentHeight = (pix.length/curWidth);
   int[] newpix = new int[pix.length];
  if(fftTransform){
  fft.forward(player.mix);  
   for( int y = 0; y < currentHeight; y++){
     float yChunk = y/(height/((bands/bandWidth)));
     if(fft.getBand(int(yChunk)%bands) > maximums[int(yChunk)%bands]){
       maximums[int(yChunk)%bands] = fft.getBand(int(yChunk)%bands); 
     }
     float normalized = fft.getBand(int(yChunk)%bands) * (1/maximums[int(yChunk)%bands]);
     normalized = handleFlip(normalized);
     for( int x = 0; x < curWidth; x++){
       int loc =  x + y*curWidth;
       int loc2 = x + y*curWidth + int(normalized*factor);
       while (loc2<0){
        loc2 = loc2+((curWidth*currentHeight)); 
       }
       float newRed = red(pix[loc]);
       float newGreen = green(pix[loc]);
       float newBlue = blue(pix[loc]);
       if(shiftRed){
         newRed = red(pix[(loc2%(curWidth*currentHeight))]);
       }
       if(shiftGreen){
         newGreen = green(pix[(loc2%(curWidth*currentHeight))]);
       }
       if(shiftBlue){
         newBlue = blue(pix[(loc2%(curWidth*currentHeight))]);
       } //<>//
       newpix[loc] = color(newRed, newGreen,newBlue);
     }
   }
  }
  else{  
   for( int y = 0; y < currentHeight; y++){
       float yChunk = y/(height/((bands/bandWidth)));
       if(player.mix.get(int(yChunk)%bands) > maximum){
         maximum = player.mix.get(int(yChunk)%bands); 
       }
       float normalized = player.mix.get(int(yChunk)%bands) * (1/maximum);
       normalized = handleFlip(normalized);
     for( int x = 0; x < curWidth; x++){
       int loc =  x + y*curWidth;
       int loc2 = x + y*curWidth + int(normalized*factor);
       while (loc2<0){
        loc2 = loc2+((curWidth*currentHeight)); 
       }
       float newRed = red(pix[loc]);
       float newGreen = green(pix[loc]);
       float newBlue = blue(pix[loc]);
       if(shiftRed){
         newRed = red(pix[(loc2%(curWidth*currentHeight))]);
       }
       if(shiftGreen){
         newGreen = green(pix[(loc2%(curWidth*currentHeight))]);
       }
       if(shiftBlue){
         newBlue = blue(pix[(loc2%(curWidth*currentHeight))]);
       }
       newpix[loc] = color(newRed, newGreen,newBlue);
     }
   }
  }
  return newpix;
 }; //
 public int[] draw(int curWidth){
   return new int[0];
 }; //

  float handleFlip(float normalized){
       if(normalized < threshold && normalized > -threshold){normalized = 0;}
       if(flipping){
         int multi = -1+(int(direction)*2);
         normalized = multi * normalized;
         direction = !direction;
       }
       return normalized;
  }
}

class LegacyKahuna extends Filter{
 
  int sleepDelay = 100;
  int[] img;
 int[] internalPixels;
 int w;
 int h;
  
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
*/
//GlitchNet
//ColorGrav
//BadDiv Params
  boolean BadDiv_Switch = false;
  float BadDiv_FactorMin = 1.005;  float BadDiv_FactorMax = 1.015;  float BadDiv_FactorStep = 0.00005;float BadDiv_ShiftMin = -2;  float BadDiv_ShiftMax = 9; float BadDiv_ColorFactor = 0.6; boolean BadDiv_RanShift=true;// Green/Pink Deepfry
  float BadDiv_Factor =BadDiv_FactorMin;  
  float BadDiv_RedFactor = (BadDiv_ColorFactor<0.01? 0.7 : BadDiv_ColorFactor);
  float BadDiv_GreenFactor = (BadDiv_ColorFactor<0.01? 0.7 : BadDiv_ColorFactor);
  float BadDiv_BlueFactor = (BadDiv_ColorFactor<0.01? 0.7 : BadDiv_ColorFactor);

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
    
    int shift =0;
    if(!BadDiv_RanShift){
      if(boolean(int(random(0,2)))){
       shift= int(-BadDiv_ShiftMin);
      }else{        
       shift= int(BadDiv_ShiftMax);
      }
    }else{
      shift =int(random(-BadDiv_ShiftMin,BadDiv_ShiftMax));
    }
    int loc = x + y*w;
    int loc2 = ((x+shift)%w)+y*w;
    int z = int((GetColorAt(safeLoc(loc))+GetColorAt(safeLoc(loc2)))/BadDiv_Factor);
    internalPixels[loc] = color(
      (red(z)*BadDiv_RedFactor)+(red(img[safeLoc(loc)])*(1-BadDiv_RedFactor)),
      (green(z)*BadDiv_GreenFactor)+(green(img[safeLoc(loc)])*(1-BadDiv_GreenFactor)),
      (blue(z)*BadDiv_BlueFactor)+(blue(img[safeLoc(loc)])*(1-BadDiv_BlueFactor))
    );
  }

//GlitchTrail Functions
  void GlitchTrail_SetPix(int x, int y){
      int loc = x + y*w;
      loc = loc+GlitchTrail_Buffer;
      float g = green((img[safeLoc(loc)]))*1;
      float b = blue((img[safeLoc(loc)]))*1;float r = 0;
      if(true){        
        r= GlitchTrail_HighestRed(img[safeLoc(loc+GlitchTrail_Delay)], internalPixels[safeLoc(loc+GlitchTrail_Echo)])*GlitchTrail_Decay; 
        r = r + random(GlitchTrail_RanMin,GlitchTrail_RanMax);
        if(g>GlitchTrail_ExcludeThreshold||b>GlitchTrail_ExcludeThreshold){
         r = r*GlitchTrail_ExcludeAmount; 
        }
      }
        if(r>g&&r>b){
          internalPixels[(loc-GlitchTrail_Buffer)%(w*h)] =  color(r,g,b);          
        }
        else{
          internalPixels[(loc-GlitchTrail_Buffer)%(w*h)] =  color(g,g,g);   
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
    int loc = x + y*w;
    float r = 0;
    if(loc+3<(w*h) && loc > 1){
      r = red(int(img[safeLoc(loc+5)]*0.1 +
        img[safeLoc(loc+3)]*0.1 +
        img[safeLoc(loc+1)]*0.3 +
        img[loc]*0.5) + internalPixels[safeLoc(loc-1)]);
    }
    else{
      r = red(int(img[loc]));
    }
    float g = green(img[loc]);
    float b = blue(img[loc]);
    if(r>g&&r>b){
      internalPixels[loc] =  color(r,g/3,b/2);          
    }
    else{
      internalPixels[loc] =  color(b,g,b);   
      
    } 
  }
  
//ColorGrav Functions

void ColorGrav_SetPix(int x, int y){
   int loc = x + y*w;
      float g = saturation(img[safeLoc(loc)]);
      float b = brightness(img[safeLoc(loc)]);
      float r = 0;
      r= ColorGrav_CircularAverage(hue(img[safeLoc(loc)]),ColorGrav_Target,ColorGrav_Force,ColorGrav_ModeMax);
      internalPixels[safeLoc(loc)] =  color(r%ColorGrav_ModeMax,(((2*ColorGrav_ModeMax)+g)/3)%(ColorGrav_ModeMax+1),b%(ColorGrav_ModeMax+1));
       
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
   return color(red(img[safeLoc(loc)]),green(img[safeLoc(loc)]),blue(img[safeLoc(loc)])); 
  };
  void setPix(int x, int y){
    int loc = x + y*w;
    internalPixels[safeLoc(loc)] = GetColorAt(safeLoc(loc));
    
  }
  int safeLoc(int loc){
    if(loc<0){
     loc = (w*h)+loc;
    }
    return loc%(w*h);
  }

 public void init(float[] parameters, int[] pix, BigKahunaPart2 parent){}; //sets up the filter with defined parameters and pixels
 public void init(int[] pix, BigKahunaPart2 parent){
   internalPixels = pix;
   init(parent);
 }; //sets up the filter with default parameters and included pixels
 public void init(BigKahunaPart2 parent){}; //sets up the filter with default parameters and included pixels
 public void configure(){};  //runs the condfiguration flow, usually a series of prompts
 public void handleKey(char k){
  switch(k){
        case 'a':{
          BadDiv_Switch=true;
           keyPressed = false;
          break;
        }
        case 'z':{
          BadDiv_Switch=false;
           keyPressed = false;
          break;
        }
        case 's':{
          GlitchTrail_Switch=true;
           keyPressed = false;
          break;
        }
        case 'x':{
          GlitchTrail_Switch=false;
           keyPressed = false;
          break;
        }
        case 'd':{
          GlitchNet_Switch=true;
           keyPressed = false;
          break;
        }
        case 'c':{
          GlitchNet_Switch=false;
           keyPressed = false;
          break;
        }
        case 'f':{
          ColorGrav_Switch=true;
          BadDiv_Switch = false;
          GlitchTrail_Switch = false;
          GlitchNet_Switch = false;
          colorMode(HSB, ColorGrav_ModeMax);
           keyPressed = false;
          break;
        }
        case 'v':{
          ColorGrav_Switch=false;
          BadDiv_Switch = false;
          GlitchTrail_Switch = false;
          GlitchNet_Switch = false;
          colorMode(RGB, 255);  
           keyPressed = false;
          break;
        }
        case 'g':{
          getModeString();
           keyPressed = false;
          break;
        }
        case '~':{
          println("looping");
           keyPressed = false;          
          break;
        }
      }}; //handles keypresses - 0-9 are reserved for switching the current active filter
 public void setPixels(int[] pix){}; //updates the internal pixels - mostly for video and webcam capture //
 public int[] draw(int curWidth){ return new int[0];};
 public int[] draw(int[] pix, int curWidth){  
      w = curWidth;
      h = (pix.length/curWidth);  
     if (internalPixels == null){
      internalPixels=pix; 
     }
     img=pix;
    //BadDiv Flip
    if(BadDiv_Switch){BadDiv_FlipDir();}
    //Pixel Loop
    for( int y = 0; y < h; y++){
      for( int x = 0; x < w; x++){      
        //Apply appropriate filter
        if(BadDiv_Switch){BadDiv_SetPix(x,y);}
        else if(GlitchTrail_Switch){GlitchTrail_SetPix(x,y);}
        else if(GlitchNet_Switch){GlitchNet_SetPix(x,y);}
        else if(ColorGrav_Switch){ColorGrav_SetPix(x,y);}
        else{setPix(x,y);}
      }
    }
  //Sleep
  try{java.util.concurrent.TimeUnit.MILLISECONDS.sleep(sleepDelay);}
  catch(Exception e){}
  return internalPixels;
}

void getModeString(){
  
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
      BadDiv_FactorMin = float(s2Arr[0]);
      BadDiv_FactorMax = float(s2Arr[1]);
      BadDiv_FactorStep = float(s2Arr[2]);
      BadDiv_ShiftMin = float(s2Arr[3]);
      BadDiv_ShiftMax = float(s2Arr[4]);
      BadDiv_ColorFactor = float(s2Arr[5]); 
      BadDiv_RedFactor = (BadDiv_ColorFactor<0.01? 0.7 : BadDiv_ColorFactor);
      BadDiv_GreenFactor = (BadDiv_ColorFactor<0.01? 0.7 : BadDiv_ColorFactor);
      BadDiv_BlueFactor = (BadDiv_ColorFactor<0.01? 0.7 : BadDiv_ColorFactor);
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
    GlitchTrail_Decay = float(s2Arr[0]);
    GlitchTrail_Delay = int(float(s2Arr[1]));
    GlitchTrail_Echo = int(float(s2Arr[2]));
    GlitchTrail_RanMin = int(float(s2Arr[3]));
    GlitchTrail_RanMax = int(float(s2Arr[4]));
    GlitchTrail_ExcludeThreshold = int(float(s2Arr[5]));
    GlitchTrail_ExcludeAmount = float(s2Arr[6]);
    GlitchTrail_Buffer = int(float(s2Arr[7]));
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
}

class PictureCollection{
  public PImage[] Collection;
  public int currentIndex;
  public long lastTick;
  public long nextTick;
  public long tickInterval;
  public boolean ticking = false;
  public PictureCollection(){
    String pathString = JOptionPane.showInputDialog("Enter a semi-colon delimited list of image paths");
    pathString = pathString.replace("\"","");
    String[] paths = pathString.split(";");
    Collection = new PImage[paths.length];
    for(int i = 0; i < paths.length; i++){  
       Collection[i]=loadImage(paths[i]);
    }
    String shouldTick = JOptionPane.showInputDialog("Should it tick? y/n");
    if(shouldTick =="y" || shouldTick =="Y"){
      ticking = true;
      String tickTime =JOptionPane.showInputDialog("Enter the tick interval");
      tickInterval = parseInt(tickTime);
    }
    
  }
}
