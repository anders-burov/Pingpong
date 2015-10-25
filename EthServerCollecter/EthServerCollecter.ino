/* Collect data, send via Ethernet
*/

#include <TinkerKit.h>
#include <SPI.h>
#include <Ethernet.h>

int sensorX = 0;
int sensorY = 0;

byte mac[] = { 0x90, 0xA2, 0xDA, 0x0D, 0x75, 0xF6 };
byte ip[] {192,168,5,10};
int eth_port = 5555;

EthernetServer server(eth_port);
boolean alreadyConnected = false;

void setup() {
  Ethernet.begin(mac, ip);
  
  Serial.begin(9600);
  Serial.print("Server address: ");
  Serial.println(Ethernet.localIP());
}

void loop() {
 EthernetClient client = server.available();

 if (client) {
   if (!alreadyConnected) {
     Serial.println("We have a new client");
     while (client.available() < 0) {
       client.println("hello");
       delay(300);
     }
     alreadyConnected = true;
     Serial.println("Connection established");
   }
   
   if (client.available() > 0) {
     char inByte = client.read();
     
     sensorX = analogRead(I0);
     sensorY = analogRead(I1);
    
     client.print(sensorX, DEC);
     client.print(",");
     client.println(sensorY, DEC);
  
     delay(100);
   }
 }
}
