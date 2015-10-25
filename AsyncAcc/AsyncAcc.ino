/* This sketch reads accelerometer values, normalizes them in [0;100]
   and then sends to the processing on the serial port
*/

#include <TinkerKit.h>

int sensorX = 0;
int sensorY = 0;

void setup() {
  Serial.begin(9600);
  while (Serial.available() <= 0)  {
    Serial.println("hello");
    delay(300);
  }
}

void loop() {
  
 if (Serial.available() > 0) {
   int inByte = Serial.read();
  
    sensorX = analogRead(I0);
    sensorY = analogRead(I1);
    
    Serial.print(sensorX, DEC);
    Serial.print(",");
    Serial.println(sensorY, DEC);
  
    delay(100);
 }
}
