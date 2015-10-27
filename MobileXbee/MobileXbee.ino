/* Mobile Xbee */

#include <TinkerKit.h>

char paddleData = 0;
int leftThreshold = 550;
int rightThreshold = 450;

void setup() {
  Serial.begin(9600);
}

void loop() {
  
  readSensor();
    
  if (paddleData != 0) {
    Serial.print(paddleData);
    paddleData = 0;
  }
  
  delay(300);
}

void readSensor() {
  int y = analogRead(I1);
  if (y > leftThreshold) {
    paddleData = 'l';
  } else if (y < rightThreshold) {
    paddleData = 'r';
  } else {
    paddleData = 0;
  }
}
  
