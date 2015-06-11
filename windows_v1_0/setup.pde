void setup() {

  //Initialize Screen
  InitScreen();
  
  //SETUP KINECT
  InitKinect();

  //  kinect.enableRGB();

  //  background(200, 0, 0);
  //  size(kinect.depthWidth() + kinect.rgbWidth()+10, kinect.rgbHeight());

  //--Initializing Texts
  InitFonts();

  //Custom
  //initialize audio
  InitAudio();




  //test
  //t1 = new OscillatorThread(1,"testID");
  //t1.start();

  //testers
//  initi();

  println(PFont.list());
}

void stop() {
  player.close();
  minim.stop();
  println("stop");
  super.stop();
}

