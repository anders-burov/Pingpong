#include <SPI.h>
#include <Ethernet.h>

byte mac[] = { 0x90, 0xA2, 0xDA, 0x0D, 0x75, 0xF6 };
byte ip[] {192,168,5,10};
int port = 5555;

EthernetServer server(port);

void setup() {
  Ethernet.begin(mac, ip);
  Serial.begin(9600);
  Serial.print("Server address:");
  Serial.println(Ethernet.localIP());
}


void loop()
{
  EthernetClient client = server.available();
  
  if (client) {
    if (client.available() > 0) {
      char c = client.read();
      Serial.write(c);
    }
  }
}
