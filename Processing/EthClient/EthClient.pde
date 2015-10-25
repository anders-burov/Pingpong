/* Client, connects to Arduino on IP, and then asks for samples
   to draw.
*/

import processing.net.*;

Client client;
int port = 5555;

void setup() {
  size(200, 200);
  println("hey!");
  try {
    client = new Client(this, "192.168.5.10", port);
  } catch (RuntimeException e) {
    println("Failed to connect");
    e.printStackTrace();
  }
}

void draw() {
  try {
    background(0);
    println("hello?");
    client.write("hello\n");
    delay(1000);
  } catch (RuntimeException e) {
    e.printStackTrace();
  }
}
