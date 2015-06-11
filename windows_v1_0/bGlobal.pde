//---PROGRAM


//---GENERAL
//--Mode
boolean isSynth=false;          //Current Mode
boolean kinectSynth=true;      //Kinect Mode
//--Text
//HashMap infoText = new HashMap();
//HashMap msgText = new HashMap();
String[] infoText = new String[6];
String[] msgText = new String[6];
String supportText, tempText;


//---AUDIO
//--Synth
boolean isSine = false;
boolean isSaw = false;
boolean isPulse = false;
boolean waveOn = false;        //Wave Active


//--Player
boolean isPlaying = false;     //Currently Playing Audio

//--Effects
boolean isLowPass = false;



//---KINECT
//--Setups
float zoom = 0f;
float rotationX = radians(180);  //OpenNI sends data rotated by 180deg around X
float rotationY = radians(0);    //OpenNI send data normal on Y
boolean autoCalibration = true;
//--PlayerData
PVector bodyCenter = new PVector();
PVector bodyDirection = new PVector();
PVector rightHand = new PVector();
PVector leftHand = new PVector();
PVector rightElbow = new PVector();
PVector leftElbow = new PVector();
PVector rightShoulder = new PVector();
PVector leftShoulder = new PVector();
PVector rightHip = new PVector();
PVector leftHip = new PVector();
PVector head = new PVector();
//--Initialization
boolean isInitialized = false;
float handRadius = 0;
float xAxis = 0;
float yAxis = 0;
float zAxis = 0;
float maxHeight, minHeight;
float maxWidth, minWidth;
float diff;

boolean switched=false;

//Tests
int testCount = 0;
boolean oscillatorOn=false;
boolean oscillatorEffectOn=false;


