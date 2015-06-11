PFont titleFont;
PFont mouseFont;
PFont infoFont;

void InitScreen(){
  //set window background colour
  background(0, 0, 0);
  //set window size
  size(1024, 600);
  //set draw() rate
  frameRate(30);
  //smooth enabled (optional)
  smooth();
  
  //image mode
  imageMode(CENTER);
  
      println("Screen Initialized");
    enqueueMsg("Screen Initialized");

}


void InitFonts() {
  titleFont=createFont("Asimov", 24, true);
  mouseFont=createFont("Moire Light", 12, true);
  infoFont=createFont("Courier New", 12, true);
}

void DrawElements() {

  //TITLE text(mode)
  noStroke();
  textFont(titleFont);
  textAlign(CENTER);
  fill(255, 255, 255);
  if(kinectSynth==true){  text("Synth Mode 0.1", width/2, 30);}
  else{ text("Filter Mode 0.1", width/2, 30);}



  //MOUSE text(coordinates)
  noStroke();
  textFont(mouseFont);
  textAlign(LEFT);
  fill(255, 255, 255);
  text(mouseX + " : "+mouseY, mouseX, mouseY);


  //INFO AREA
  rectMode(RADIUS);
  strokeWeight(2);
  stroke(250, 250, 100);
  noFill();
  rect(3*(width/4), height-35, 250, 30);

  //MESAGE AREA
  rectMode(RADIUS);
  strokeWeight(2);
  stroke(250, 250, 100);
  noFill();
  rect(width/4, height-35, 250, 30);
}

void DrawText() {

  //INFO TEXT
  if (infoText[0]!=null) {
    noStroke();
    textFont(infoFont);
    textAlign(LEFT);
    fill(0, 0, 255);
    for (int i =0; i<5;i++) {
      text(infoText[i], width/2+10, (height-68)+((i+1)*12));
      if (i==4)break;
      if(infoText[i+1]==null)break;
    }
  }
  
    //MSG TEXT
  if (msgText[0]!=null) {
    noStroke();
    textFont(infoFont);
    textAlign(LEFT);
    fill(255, 0, 0);
    for (int i =0; i<5;i++) {
      text(msgText[i], 10, (height-68)+((i+1)*12));
      if (i==4)break;
      if(msgText[i+1]==null)break;
    }
  }
  
  
}

