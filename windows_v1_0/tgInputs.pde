//KEYBOARD input handling
void keyPressed() {
  if (key=='P'||key=='p') {
    if (!player.isPlaying())   player.play();
    else player.pause();
    //play-pause
  }
  else if (key=='S'||key=='s') {
    player.cue(0);
    player.pause();
    //stop
  }
  else if (key=='O'||key=='o') {
    if (oscillatorOn=false)CreateOscillator(1, 1, 44100);
    else RemoveOscillator();
  }
  else if (key=='E'||key=='e') {
    if (oscillatorEffectOn)RemoveOscillatorEffect();
    else AddOscillatorEffect();
  }
  else if (key=='L'||key=='l') {
    if (!isLowPass)
      AddLowPassFilter();
    else if (isLowPass)
      RemoveLowPassFilter();
  }
  else if (key=='Q'||key=='q') {
    if (isSaw) {
      DeleteSawWave();
    }
    else {
      CreateSawWave();
    }
  }
  else if (key=='I'||key=='i') {
    isInitialized=false;
  }
}

//MOUSE DRAG handling
void mouseDragged() {
  if (mouseX!=mX||mouseY!=mY) {
    if (!waveOn) {
      mX=mouseX;
      mY=mouseY;
      println(mouseX);
      if (mouseX>1&&mouseX<1014)CreateAudioWave(map(mouseX, 0, 1024, 0, 20000), map((height-mouseY), 0, 600, 0, 1), sine);
    }
    else {
      UpdateAudioWave(sine);
    }
  }
}



void mousePressed() {
  if (mouseX>1&&mouseX<1014)
    CreateAudioWave(map(mouseX, 0, 1024, 0, 20000), map((height-mouseY), 0, 600, 0, 1), sine);
  /*
 if(mouseButton==LEFT)
   else if(mouseButton==RIGHT)
   else if(mouseButton==CENTER)
   else{}*/
}

void mouseReleased() {
  locked=false;
  DeleteAudioWave(sine);
}




//----------MOUSE


float bx;
float by;
int bs = 20;
boolean bover = false;
boolean locked = false;
float bdifx = 0.0; 
float bdify = 0.0; 

float mX =0.0f;
float mY = 0.0f;

