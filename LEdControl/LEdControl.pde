import processing.serial.*;
Serial port;
short brightness = 0;
float redFactor = 2;
float greenFactor = 0.5;
float blueFactor = 0.5; 
float scalor = 10;
import processing.sound.*;

int lastR = 0;
int lastG = 0;
int lastB = 0;

AudioIn song;
//SoundFile song;

FFT fft;
Waveform wvf;
int bands =8;
float[] spectrum = new float[bands];
float[] maximums = new float[bands];
int direction = 1;
float mediator =1;
float bleed = 0.9999999;
long drawFrame;

void setup(){
   size(500,500);
  background(0);
 port = new Serial(this, "COM5", 9600);
 
  port.write(255);
  port.write(255);
  port.write(255);
    //song = new SoundFile(this, "C:\\Users\\read-0nly\\Downloads\\y2mate.com - Breathe. Are You All Good Official Video..mp3");
 //song.loop();
  song = new AudioIn(this,1);
  song.start();
  
    drawFrame =System.currentTimeMillis();

  wvf = new Waveform(this, bands);
  fft = new FFT(this, bands);
  wvf.input(song); 
  fft.input(song);
 
}

void draw(){
  
  loadPixels();
  
  fft.analyze(spectrum);
  int max = 0;
  for(int i = 0; i < bands; i++){
     if(spectrum[int(i)%bands] > maximums[int(i)%bands] && spectrum[int(i)%bands] > 0.0002){
       maximums[int(i)%bands] = spectrum[int(i)%bands]; 
     }
     
 if(System.currentTimeMillis()-drawFrame>10){
     sendNormed(0,2,4,1,5,3);
  drawFrame =System.currentTimeMillis();
}
     
     
     maximums[int(i)%bands] = maximums[int(i)%bands] * bleed;
    
  }
  /*
  wvf.analyze(spectrum);
  int max = 0;
  for(int i = 0; i < bands; i++){
     if(spectrum[int(i)%bands] > maximums[int(i)%bands]){
       maximums[int(i)%bands] = spectrum[int(i)%bands]; 
     }
     float normalized = 0 ;
     if((maximums[int(i)%bands]*mediator)>0){
       normalized = spectrum[int(i)%bands] * (1/(maximums[int(i)%bands]*mediator));
     }
     if(normalized > 1){
      normalized = 1; 
     }
     int redVal = int(normalized * 255);
     port.write(redVal);
     
     maximums[int(i)%bands] = maximums[int(i)%bands] * bleed;
    
  }
  */
}

void sendNormed(int r, int rwidth, int g, int gwidth, int b, int bwidth){
 
     float normalized = 0 ;
     for(int i = r; i < r+rwidth; i++){
       if((maximums[int(i)%bands]*mediator)>0){
         normalized += spectrum[int(i)%bands] * (1/(maximums[int(i)%bands]*mediator));
       }        
     }
     normalized = normalized / rwidth;
     if(normalized > 1){
      normalized = 1; 
     }
     int redVal = int(normalized * 255*redFactor);
     if(redVal<lastR){
       redVal = int(((lastR*scalor)+redVal)/(scalor+1));
       if(redVal>255){
         redVal=255;
       }
     }
      port.write(int(redVal*redFactor)); 
      lastR=redVal;
     
     normalized = 0 ;
     for(int i = g; i < g+gwidth; i++){
       if((maximums[int(i)%bands]*mediator)>0){
         normalized += spectrum[int(i)%bands] * (1/(maximums[int(i)%bands]*mediator));
       }    
     }
     normalized = normalized / gwidth;
     if(normalized > 1){
      normalized = 1; 
     }
    int greenVal = int(normalized * 255*greenFactor);
    if(greenVal<lastG){
       greenVal = int(((lastG*scalor)+greenVal)/(scalor+1));
       if(greenVal>255){
         greenVal=255;
       }
     }
      port.write(int(greenVal*greenFactor)); 
     lastG=greenVal;
     
     normalized = 0 ;
     for(int i = b; i < b+bwidth; i++){
       if((maximums[int(i)%bands]*mediator)>0){
         normalized += spectrum[int(i)%bands] * (1/(maximums[int(i)%bands]*mediator));
       }        
     }
     normalized = normalized / rwidth;
     if(normalized > 1){
      normalized = 1; 
     }
     
     int blueVal = int(normalized * 255*blueFactor);
    if(blueVal<lastB){
       blueVal = int(((lastB*scalor)+blueVal)/(scalor+1));
       if(blueVal>255){
         blueVal=255;
       }
     }
     port.write(int(blueVal*blueFactor)); 
     lastB=blueVal;
     
     /*
     
     int redVal = 256;
     int greenVal = 256;
     int blueVal = 256;
     
     byte[] packet = new byte[3];
     packet[0]=byte(redVal);
     packet[1]=byte(greenVal);
     packet[2]=byte(blueVal);
     println(packet);
     */
}
void keyPressed(){
  switch(key){
    //Keys reserved for filter switching
     case '1':{
       port.write(0);
       println(0);
       break;
     }
     case '2':{
       port.write(255);
       println(255);
       break;
     }
     default:{
       
     }
  }
}
