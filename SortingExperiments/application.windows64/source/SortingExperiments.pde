  PImage img; //<>//
  import javax.swing.JOptionPane;
  String mode = "hue";
  String[] possibilities = {"hue","saturation","brightness","red","green","blue"};
  int step=0;
  int maxStep = 35565;
  int maxIndex=0;
  
  void loadFile(){
    String file = ((String)JOptionPane.showInputDialog(
      frame, 
      "File Path", 
      "File Path", 
      JOptionPane.PLAIN_MESSAGE, 
      null, 
      null, 
      "Load File")).replace("\"", "");
    println(file);
    img = loadImage(file);  
    float scaleFactor = parseFloat(((String)JOptionPane.showInputDialog(
      frame, 
      "scaling factor", 
      "scaling factor", 
      JOptionPane.PLAIN_MESSAGE, 
      null, 
      null, 
      "")).replace("\"", ""));
      img.resize(int(img.width*scaleFactor), int(img.height*scaleFactor));
    size(img.width,img.height);
    maxIndex=(width*height);  
  }
  void setSortMode(){    
    mode= (String)JOptionPane.showInputDialog(
      frame,
      "Pick the mode",
      "Mode",
      JOptionPane.PLAIN_MESSAGE,
      null,
      possibilities,
      "hue");
    step=0;
    
  }
  void settings() {
    loadFile();
    setSortMode();

  }
  void drawImage(){
    img.loadPixels();
    loadPixels();
    for (int x =0; x<width; x++) {
      for (int y = 0; y<height; y++) {      
        pixels[((x+(y*width))%maxIndex)] = img.pixels[((x+(y*width))%maxIndex)];
      }
    }
    updatePixels();
    
  }
  void setup() {
    colorMode(HSB);
    drawImage();
  }
  
  void draw() {
    loadPixels();
    for (int x =0; x<width; x++) {
      int[] column = new int[height]; 
      for (int y = height-1; y>0; y--) {      
        //bubbleSort(x,y);
        column[y]=pixels[((x+(y*width))%maxIndex)];
      }
  
      if (step < column.length-1 && step<maxStep) {
        int[] result = selectSort(column, step);
        for(int i = 0; i<result.length;i++){
          pixels[((x+(i*width))%maxIndex)]=result[i];
        }
      }
    }
        step++;
    updatePixels();
  }
  
  void bubbleSort(int x, int y) {
  
    if (y>1) {
      if (
        hue(pixels[((x+(y*width))%maxIndex)])
        <
        hue(pixels[((x+((y-1)*width))%maxIndex)])
        ) {
        int pixel = pixels[((x+((y-1)*width)))];
        pixels[((x+((y-1)*width))%maxIndex)] = pixels[((x+(y*width)))];
        pixels[((x+(y*width)))] = pixel;
      }
    }
  }
  
  int[] selectSort(int[] pixelsToSort, int curstep) {
    switch(mode) {
    case "hue":
      {
        int mindex = 0;
        if (mindex<curstep) {
          mindex=curstep;
        }
  
        for (int j = curstep; j<pixelsToSort.length; j++) {
          if (mindex!=j&&hue(pixelsToSort[mindex])>hue(pixelsToSort[j])) {
            mindex = j;
          }
        }
        if (mindex!=curstep) {
          int bucket = pixelsToSort[curstep];
          pixelsToSort[curstep]=pixelsToSort[mindex];
          pixelsToSort[mindex]=bucket;
        }
  
        break;
      } 
    case "saturation":
      {
        int mindex = 0;
        if (mindex<curstep) {
          mindex=curstep;
        }
  
        for (int j = curstep; j<pixelsToSort.length; j++) {
          if (mindex!=j&&saturation(pixelsToSort[mindex])>saturation(pixelsToSort[j])) {
            mindex = j;
          }
        }
        if (mindex!=curstep) {
          int bucket = pixelsToSort[curstep];
          pixelsToSort[curstep]=pixelsToSort[mindex];
          pixelsToSort[mindex]=bucket;
        }
  
        break;
      } 
    case "brightness":
      {
        int mindex = 0;
        if (mindex<curstep) {
          mindex=curstep;
        }
  
        for (int j = curstep; j<pixelsToSort.length; j++) {
          if (mindex!=j&&brightness(pixelsToSort[mindex])>brightness(pixelsToSort[j])) {
            mindex = j;
          }
        }
        if (mindex!=curstep) {
          int bucket = pixelsToSort[curstep];
          pixelsToSort[curstep]=pixelsToSort[mindex];
          pixelsToSort[mindex]=bucket;
        }
  
        break;
      } 
    case "red":
      {
        int mindex = 0;
        if (mindex<curstep) {
          mindex=curstep;
        }
  
        for (int j = curstep; j<pixelsToSort.length; j++) {
          if (mindex!=j&&red(pixelsToSort[mindex])>red(pixelsToSort[j])) {
            mindex = j;
          }
        }
        if (mindex!=curstep) {
          int bucket = pixelsToSort[curstep];
          pixelsToSort[curstep]=pixelsToSort[mindex];
          pixelsToSort[mindex]=bucket;
        }
  
        break;
      } 
    case "green":
      {
        int mindex = 0;
        if (mindex<curstep) {
          mindex=curstep;
        }
  
        for (int j = curstep; j<pixelsToSort.length; j++) {
          if (mindex!=j&&green(pixelsToSort[mindex])>green(pixelsToSort[j])) {
            mindex = j;
          }
        }
        if (mindex!=curstep) {
          int bucket = pixelsToSort[curstep];
          pixelsToSort[curstep]=pixelsToSort[mindex];
          pixelsToSort[mindex]=bucket;
        }
  
        break;
      } 
    case "blue":
      {
        int mindex = 0;
        if (mindex<curstep) {
          mindex=curstep;
        }
  
        for (int j = curstep; j<pixelsToSort.length; j++) {
          if (mindex!=j&&blue(pixelsToSort[mindex])>blue(pixelsToSort[j])) {
            mindex = j;
          }
        }
        if (mindex!=curstep) {
          int bucket = pixelsToSort[curstep];
          pixelsToSort[curstep]=pixelsToSort[mindex];
          pixelsToSort[mindex]=bucket;
        }
  
        break;
      } 
    default:
      {
        int mindex = 0;
        if (mindex<curstep) {
          mindex=curstep;
        }
  
        for (int j = 0; j<pixelsToSort.length; j++) {
          if (mindex!=j&&pixelsToSort[mindex]>pixelsToSort[j]) {
            mindex = j;
          }
        }
        if (mindex!=curstep) {
          int bucket = pixelsToSort[curstep];
          pixelsToSort[curstep]=pixelsToSort[mindex];
          pixelsToSort[mindex]=bucket;
        }
      }
    }
    return pixelsToSort;
  }
  
  
  void keyPressed(){
    switch(key){
      
       case 's':{
         String file = ((String)JOptionPane.showInputDialog(
          frame, 
          "File Path", 
          "File Path", 
          JOptionPane.PLAIN_MESSAGE, 
          null, 
          null, 
          "Load File")).replace("\"", "");
         save(file);
         break;
       }
       case 'm':{
         setSortMode();
         setup();
         break;
       }
    }
  }
