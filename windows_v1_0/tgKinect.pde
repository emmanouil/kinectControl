
void InitKinect() {

  kinect = new SimpleOpenNI(this);
  kinect.setMirror(false);

  if (kinect.enableDepth() ==false) {
    println("ERROR Kinect Cannot Be Initialized");
    enqueueMsg("Kinect Cannot Be Initialized (check connection?)");
    stop();
  }
  else {
    println("Kinect Initialized");
    enqueueMsg("Kinect Initialized");
  }

  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
}


void UpdateKinect() {
  kinect.update();


  image(kinect.depthImage(), 512, 280);




  int[] userList = kinect.getUsers();
  for (int i=0;i<userList.length;i++)
  {
    if (kinect.isTrackingSkeleton(userList[i])) {
      GetInputs(userList[i]);
      //Initializing
      if (  (!isInitialized)&&(leftHand.y<leftHip.y)&&(rightHand.y<rightHip.y)) {
        maxHeight = head.y*1.10f;
        minHeight = ((leftHip.y-(abs(leftHip.y)*0.3))+(rightHip.y-(abs(rightHip.y)*0.3)))/2;
        diff = dist(0,minHeight,0,maxHeight);
//        enqueueMsg("LHip:"+leftHip.y+"LShoulderX:"+leftShoulder.x+"LShoulderY"+leftShoulder.y);
        minWidth = leftShoulder.x-2.0*dist(leftShoulder.x, leftShoulder.y, leftShoulder.z, leftHand.x, leftHand.y, leftHand.z);
        maxWidth = rightShoulder.x+2.0*dist(rightShoulder.x, rightShoulder.y, rightShoulder.z, rightHand.x, rightHand.y, rightHand.z);;
        enqueueMsg("Initialized. L: "+nf(minWidth,3,1)+"  R: "+nf(maxWidth,3,1)+"  Top: "+nf(maxHeight,3,1)+"  Bottom: "+nf(minHeight,3,1));
        isInitialized=true;
      }
    }
  }
}   


//int[] depthMap = kinect.depthMap();
//int steps = 1;
//int index;




void GetInputs(int userID) {
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_HAND, leftHand);
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HAND, rightHand);
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW, leftElbow);
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_ELBOW, rightElbow);
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, leftShoulder);
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, rightShoulder);
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HIP, rightHip);
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_HIP, leftHip);
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_HEAD, head);
//  print(rightHand.x+"  "+rightHand.y+"   "+rightHand.z);
  return;
}



//NOT USED
void InitializeUser() {

  float rightTemp, leftTemp, temp;
  rightTemp = dist(rightHand.x, rightHand.y, rightHand.z, rightElbow.x, rightElbow.y, rightElbow.z);
  leftTemp = dist(leftHand.x, leftHand.y, leftHand.z, leftElbow.x, leftElbow.y, leftElbow.z);
  rightTemp = rightTemp + dist(rightShoulder.x, rightShoulder.y, rightShoulder.z, rightElbow.x, rightElbow.y, rightElbow.z);
  leftTemp = leftTemp + dist(leftShoulder.x, leftShoulder.y, leftShoulder.z, leftElbow.x, leftElbow.y, leftElbow.z);
  temp = (rightTemp + leftTemp)/2;
  enqueueMsg("Initialized. Av.Length: "+temp+"  Left: "+leftTemp+"   Right: "+rightTemp);
  isInitialized=true;
}






// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(int userId)
{
  println("NewUser? - userId: " + userId);
  enqueueMsg("NewUser? - userId: " + userId);

  if (autoCalibration) {
    enqueueMsg("AutoCalibrating User: " + userId);
//    isInitialized=false;
    kinect.requestCalibrationSkeleton(userId, true);
  }
  else    
    kinect.startPoseDetection("Psi", userId);
}

void onLostUser(int userId)
{
  println("Lost User: " + userId);
  enqueueMsg("Lost User: " + userId);
}

void onExitUser(int userId)
{
  println("Exit User: " + userId);
  enqueueMsg("Exit User: " + userId);
}

void onReEnterUser(int userId)
{
  println("ReEnterUser: " + userId);
  enqueueMsg("ReEnterUser: " + userId);
}

void onStartCalibration(int userId)
{
  println("StartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("EndCalibration - userId: " + userId + ", successfull: " + successfull);

  if (successfull) 
  { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");

  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose, int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

