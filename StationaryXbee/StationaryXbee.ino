/* Stationaty Xbee, don't forget to switch to MICRO mode */

#include <SPI.h>
#include <Ethernet.h>

byte mac[] = { 0x90, 0xA2, 0xDA, 0x0D, 0x75, 0xF6 };
byte ip[] {192,168,5,10};
int port = 5555;

EthernetServer server(port);

void setup() {
  Serial.begin(9600);
  Ethernet.begin(mac, ip);
}

void loop() {
  
  EthernetClient client = server.available();
  
  char paddleData = Serial.read();
  
  /*if (paddleData == 'l' ||
      paddleData == 'r') {
        Serial.write(paddleData);
      }
  */
          
  if (client) {
    if (client.available() > 0) {
        switch (paddleData) {
        case 'l':
        case 'r':
        client.print(paddleData);
        }
    }
  }
  
  delay(80);
}
