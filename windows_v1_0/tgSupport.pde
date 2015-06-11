void enqueueInfo(String value) {

  if (infoText[5]!=null) {
    for (int i=0;i<5;i++) {
      infoText[i]=infoText[i+1];
    }
    infoText[5]=nfc(float(millis())/100,1)+":  "+value;
  }
  else {
    int i=0;
    while (infoText[i]!=null)i++;
    infoText[i]=nfc(float(millis())/100,1)+":  "+value;
  }
}

void enqueueMsg(String value) {
  if (msgText[5]!=null) {
    for (int i=0;i<5;i++) {
      msgText[i]=msgText[i+1];
    }
    msgText[5]=nfc(float(millis())/100,1)+":  "+value;
  }
  else {
    int i=0;
    while (msgText[i]!=null)i++;
    msgText[i]=nfc(float(millis())/100,1)+":  "+value;
  }
}
