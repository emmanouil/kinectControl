AudioPlayer player;
AudioInput input;
AudioOutput output;
AudioMetaData meta;

boolean leftOn=false, rightOn=false;
SineWave sine, leftSine, rightSine;
SineWave osci;

SawWave saw;

OscillatorEffect oeffect;

LowPassFS lpFilter;
BandPass bpFilter;



//INITIALIZING AUDIO
void InitAudio() {
  //Creating Minim Object
  minim = new Minim(this);
  //Output
  output=minim.getLineOut(Minim.STEREO, 2048, 44100, 16);  //type:Stereo/Mono, buffer size, sample rate, bitdepth
  //Player (for files)
  player = minim.loadFile("PWSteal.mp3");
  //Testing metadata
  println(player.getMetaData().title());
  //Testing volume (NOT WORKING)
  println("Volume: " + player.getVolume());
  //meta = player.getMetaData();

  println("Audio Initialized");
  enqueueMsg("Audio Initialized");
}



//UPDATING AUDIO PARAMETERS FROM KINECT
void UpdateAudio() {
  if (isInitialized) {
    if (kinectSynth) {//case: synth mode

      if (leftHand.x<minWidth||leftHand.y<minHeight) {  
        if (leftOn==true)  DeleteWaveLeft();
      }
      if (rightHand.x>maxWidth||rightHand.y<minHeight) {  
        if (rightOn==true)  DeleteWaveRight();
      }

      if (leftOn==false) {
        if (leftHand.x>minWidth&&leftHand.y>minHeight)  CreateWaveLeft();
      }
      else  UpdateWaveLeft();

      if (rightOn==false) {
        if (rightHand.x<maxWidth&&rightHand.y>minHeight)  CreateWaveRight();
      }
      else UpdateWaveRight();

      if (rightHand.y>maxHeight&&leftHand.y>maxHeight)  CreateBandPassFilter();
    }
    else {//case: filter mode

//if(leftHand.y<maxHeight&&rightHand.y<maxHeight) UpdateBandPassFilter();

        if (leftHand.y>minHeight||rightHand.y>minHeight) UpdateBandPassFilter();
        else DeleteBandPassFilter();
    }
  }
}


//SYNTH MODE
void CreateWaveLeft() {
  leftSine = new SineWave(map(leftHand.x, minWidth, maxWidth, 0, 20000), map((maxHeight-leftHand.y), minHeight, maxHeight, 0, 1), 44100f);
  leftSine.portamento(200);
  output.addSignal(leftSine);
  enqueueInfo("Left-Hand Wave Created. Freq=  "+map(leftHand.x, minWidth, maxWidth, 0, 20000));
  leftOn=true;
  kinectSynth=true;
}

void CreateWaveRight() {
  rightSine = new SineWave(map(rightHand.x, minWidth, maxWidth, 0, 20000), map((maxHeight-rightHand.y), minHeight, maxHeight, 0, 1), 44100f);
  rightSine.portamento(200);
  output.addSignal(rightSine);
  enqueueInfo("Right-Hand Wave Created. Freq=  "+map(rightHand.x, minWidth, maxWidth, 0, 20000));
  rightOn=true;
  kinectSynth=true;
}

void UpdateWaveLeft() {
  leftSine.setFreq(map(leftHand.x, minWidth, maxWidth, 0, 20000));
//---------  println(leftHand.x);
//---------println(  map(leftHand.x, minWidth, maxWidth, 0, 20000));
  leftSine.setAmp(map((maxHeight-leftHand.y), minHeight, maxHeight, 0, 1));
}

void UpdateWaveRight() {
  rightSine.setFreq(map(rightHand.x, minWidth, maxWidth, 0, 20000));
  rightSine.setAmp(map((maxHeight-rightHand.y), minHeight, maxHeight, 0, 1));
}

void DeleteWaveLeft() {
  output.removeSignal(leftSine);
  leftOn=false;
  enqueueInfo("Left-Hand Wave Removed");
}

void DeleteWaveRight() {
  output.removeSignal(rightSine);
  rightOn=false;
  enqueueInfo("Right-Hand Wave Removed");
}



//FILTER MODE
void CreateBandPassFilter() {
  DeleteWaveLeft();  
  DeleteWaveRight();  
  player.play();
  bpFilter = new BandPass(600, 30, player.sampleRate());
  player.addEffect(bpFilter);
  kinectSynth=false;
  enqueueInfo("Synth Mode Terminated");
  enqueueMsg("Filter Mode Initiated");
}

void UpdateBandPassFilter() {

  switched=false;
  
  //calibrating
  if (rightHand.y<minHeight)rightHand.y=minHeight-1;
  if (leftHand.y<minHeight)leftHand.y=minHeight-1;
  if (rightHand.y>maxHeight)rightHand.y=maxHeight+1;
  if (leftHand.y>maxHeight)leftHand.y=maxHeight+1;

float passBand;

float distance = dist(0,rightHand.y,0,leftHand.y);
if(rightHand.y>leftHand.y)  passBand = dist(0,rightHand.y,0,maxHeight)+(distance/2);
else passBand = dist(0,leftHand.y,0,maxHeight)+(distance/2);

passBand=map(passBand,0,diff,10,10000);

float bandWidth=map(distance,0,diff,0,20000);

//  float passBand = map((abs((dist(0,minHeight,0,rightHand.y)-dist(0,minHeight,0,leftHand.y)))/2), 0, dist(0,maxHeight,0,minHeight), 1f, 10000);
//  float bandWidth = map((dist(0,rightHand.y,0,leftHand.y)), 0, dist(0,maxHeight,0,minHeight), 0f, 24000);
  bpFilter.setFreq(passBand);
  bpFilter.setBandWidth(bandWidth);
  
  println("distance: "+distance+"band: "+passBand+"  width: "+bandWidth);
}

void DeleteBandPassFilter() {
  println(leftHand.y+"   "+rightHand.y);
  if(switched){
  player.removeEffect(bpFilter);
  player.cue(0);  
  player.pause();
  kinectSynth=true;}
  else switched=true;
}








//SINE WAVE AUDIO
void CreateAudioWave(float frequency, float amplitude, SineWave audioWave) {
  //Creating the Sine Wave
  sine = new SineWave(frequency, amplitude, 44100f);
  //Smoothing 20ms
  sine.portamento(200);
  //Adding Sine Wave to the actual Output
  output.addSignal(sine);
  //Testing
  println("Sine Created + Added. Freq=  "+frequency);
  enqueueInfo("Audio Sine Wave Created. Freq=  "+frequency);
  waveOn=true;
}

void UpdateAudioWave(SineWave audioWave) {
  sine.setFreq(map(mouseX, 0, 1024, 0, 20000));

  sine.setAmp(map((height-mouseY), 0, 600, 0, 1));
}

void DeleteAudioWave(SineWave audioWave) {
  output.removeSignal(sine);
  waveOn=false;
  println("removed");
}



//SAW WAVE AUDIO
void CreateSawWave() {
  saw = new  SawWave();
  output.addSignal(saw);
  isSaw=true;
}

void DeleteSawWave() {
  output.removeSignal(saw);
  isSaw=false;
}


//LOW PASS FILTER EFFECT
void AddLowPassFilter() {
  lpFilter = new LowPassFS(1000, player.sampleRate());
  player.addEffect(lpFilter);
  isLowPass=true;
}

void RemoveLowPassFilter() {
  player.removeEffect(lpFilter);
  isLowPass=false;
}




//OSCILATOR TEST
void AddOscillatorEffect() {
  oeffect = new OscillatorEffect();
  output.addEffect(oeffect);
  oscillatorEffectOn=true;
}

void RemoveOscillatorEffect() {
  output.removeEffect(oeffect);
  oscillatorEffectOn=false;
}





//NOT
void CreateOscillator(float frequency, float amp, float sampleRate) {
  osci = new SineWave(frequency, amp, sampleRate);
  oscillatorOn = true;
}

void RemoveOscillator() {
  //osci = new
}







class OscillatorEffect implements AudioEffect
{
  void process(float[] samp)
  {

    /*
    float[] effected = new float[samp.length];
     int i = samp.length - 1;
     for (int j = 0; j < effected.length; i--, j++)
     {
     effected[j] = samp[i];
     }
     // we have to copy the values back into samp for this to work
     arraycopy(effected, samp);
     */
    //float[] effected = new float[samp.length];
    for (int j = 0; j < (samp.length -1); j++)
    {
      samp[j] = samp[j]*(sin(TWO_PI*(millis()*1000)));
      //  Normal:      samp[j] = samp[j]*(sin(TWO_PI*Frequency*(millis()*1000)));
    }
    // we have to copy the values back into samp for this to work
    //arraycopy(effected, samp);
  }

  void process(float[] left, float[] right)
  {
    process(left);
    process(right);
  }
}

