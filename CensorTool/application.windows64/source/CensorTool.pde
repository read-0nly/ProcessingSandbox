import javax.swing.JOptionPane;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;
int width = 50;
int height = 30;
int swidth=500;
int sheight=500;
PImage image;
int[] pixArr = new int[swidth * sheight]; 
String[] Values = {
 "John",
 "Doe",
 "John Doe",
 "john.doe@factory.com",
 "john.doe@factory.onmicrosoft.com",
 "Factory Inc",
 "factory.com",
 "factory.onmicrosoft.com",
 "12a3b45c-67de-8f9a-bc12-34d5e6fab789c" 
};
int stringmode = 0;
int stringsize = 12;
boolean reloadImage = true;

String helpMsg = 
"[Text String keys]"+"\n"+ 
"\tQ:FName | W:LName | E:FullName | R:UPN | T:UPNOnMS"+"\n"+ 
"\tA:CompanyName | S:Domain | D:DomainOnMS | F: GUID"+"\n"+ 
"\tF1:HELP | F2:SAVE | F3:REFRESH"+"\n";
void settings() {
  File saveFile;
          JFileChooser saveChooser = new JFileChooser();
          FileNameExtensionFilter filter = new FileNameExtensionFilter(
              "JPG Image", "jpg", "jpeg");
          saveChooser.setFileFilter(filter);
          int returnVal = saveChooser.showOpenDialog(this.frame);
          while(returnVal != 0){
            returnVal = saveChooser.showOpenDialog(this.frame);
          }
          saveFile= saveChooser.getSelectedFile();
          String path = saveFile.getPath();
    image = loadImage(path);  
  swidth = image.width;
  sheight=image.height;
  size(swidth, sheight);
  
}

void draw() {
  if(keyPressed){
   switch(key){
    //Mode Handlers
    case 'q':{
      stringmode = 0;
     break; 
    }
    case 'w':{
      stringmode = 1;
     break; 
    }
    case 'e':{
      stringmode = 2;
     break; 
    }
    case 'r':{
      stringmode = 3;
     break; 
    }
    case 't':{
      stringmode = 4;
     break; 
    }
    case 'a':{
      stringmode = 5;
     break; 
    }
    case 's':{
      stringmode = 6;
     break; 
    }
    case 'd':{
      stringmode = 7;
     break; 
    }
    case 'f':{
      stringmode = 8;
     break; 
    }
    //FontSize Handlers
    case '1':{
      stringsize = 10;
     break; 
    }
    case '2':{
      stringsize = 12;
     break; 
    }
    case '3':{
      stringsize = 14;
     break; 
    }
    case '4':{
      stringsize = 16;
     break; 
    }
    case '5':{
      stringsize=18;
     break; 
    }
    default:{
      //keycode 112 is f1
      switch(keyCode){
        case 112:{
          if(keyPressed){JOptionPane.showMessageDialog(null,helpMsg, "Help Message", JOptionPane.PLAIN_MESSAGE);}
          
          keyCode=0;
          break;
        }
        case 113:{
          File saveFile;
          JFileChooser saveChooser = new JFileChooser();
          FileNameExtensionFilter filter = new FileNameExtensionFilter(
              "JPG Image", "jpg", "jpeg");
          saveChooser.setFileFilter(filter);
          int returnVal = saveChooser.showSaveDialog(this.frame);
          if(returnVal == 0){
            saveFile= saveChooser.getSelectedFile();
            String path = saveFile.getPath();
            if(!path.contains(".jp")){
             path = path+".jpg"; 
            }
            save(path);
          }
          keyCode=0;
          break;
        }
        case 114:{
          reloadImage = true;
          keyCode=0;
          break;
        }
        default:{
         break; 
        }
      };
      
     break; 
    }
   }
  }
  background(126);
  if(reloadImage){
    loadPixels();
    image.loadPixels();
    pixArr = new int[pixels.length];
    for(int i = 0; i < pixels.length; i++){
     pixels[i]=pixArr[i]=image.pixels[i]; 
    }
    reloadImage=false;
  }
  updatePixels();
  pixels = pixArr;
  fill(0);
  rect(mouseX-int(width/2), mouseY-int(height/2), width, height);    // Top circle
  fill(255);
  textAlign(CENTER,CENTER);
  textSize(stringsize);
  text(Values[stringmode],mouseX-int(width/2), mouseY-int(height/2), width, height);
  
}




void mousePressed() {
  loadPixels();
  pixArr = pixels;
  updatePixels();
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  println(e);
  if(keyPressed && keyCode == SHIFT){
    height = int(height+e);
  }
  else{
    width = int(width+(e*3));
  }
}
