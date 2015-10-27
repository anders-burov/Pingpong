/* FrontEnd connecting to EthernetServer, asking for data
  and visualizing it
  Server sits on 192.168.5.10:5555
*/

import processing.serial.*;
import processing.net.*;

Client client;
int port = 5555;

public class Paddle {
  int Height = 50;
  int Width = 10;
  int X; int Y;
  int score;
  
  public Paddle(int x, int y) {
    X = x; Y = y; score = 0;
  }
  
  public void move(int delta) {
    int newPosition = Y - delta;
    Y = constrain(newPosition, 0, height-Height);
  }
  
  public void display() {
    rect(X, Y, Width, Height);
  }
  
  public void reset() {
    score = 0;
    Y = height/2;
  }
}

Paddle left;
Paddle right;

boolean paused = false;

int ballSize = 10;
int xDir = 1;
int yDir = 1;
int xPos, yPos;

PFont font;
int fontSize = 36;

void setup() {
  size(640, 480);
  frameRate(60);
  noStroke();
  
  try {
    println("Connecting to server");
    client = new Client(this, "192.168.5.10", port);
    client.write("hello\n");
    println("Connection established");
  } catch (RuntimeException e) {
    e.printStackTrace();
    exit();
  }
  
  left = new Paddle(50, height/2);
  right = new Paddle(width-50, height/2);
 
  resetBall();
  font = createFont(PFont.list()[2], fontSize);
  textFont(font); 
  
  println("Setup finished");
}

void draw() {
  background(0);
  left.display();
  right.display();
  
  if (paused == false) {
    animateBall();
  } else {
    textAlign(CENTER);
    text("PRESS P TO PLAY", width/2, height/2);
    rect(xPos, yPos, ballSize, ballSize);
  }
  
  textAlign(CENTER, TOP);
  text(left.score, fontSize, fontSize);
  text(right.score, width-fontSize, fontSize);
}

void clientEvent(Client client) {
  try {
    /*String string = client.readStringUntil(linefeed);
    if (string != null) {
      string = trim(string);
    }*/
    
    switch(client.readChar()) {
      case 'l':
      right.move(-20);
      break;
      case 'r':
      right.move(20);
      break;
    }
    
    client.write('\n');
  } catch (RuntimeException e) {
    e.printStackTrace();
  }
}

void keyPressed() {
  if (key == 'r') {
    paused = true;
    left.reset();
    right.reset();
    resetBall();
  }
  if (key == 'p') {
    paused = !paused;
    println("P PRESSED");
  }
  if (key == 'w') {
    left.move(3);
  }
  if (key == 's') {
    left.move(-3);
  }
  if (key == CODED) {
    if (keyCode == UP) {
      xDir = xDir * 2;
      yDir = yDir * 2;
    }
    if (keyCode == DOWN) {
      if (xDir > 1 && yDir > 1) {
        xDir = xDir / 2;
        yDir = yDir / 2;
      }
    }
  }
}

void resetBall() {
  xPos = width/2;
  yPos = height/2;
}

void animateBall() {
 
  if (xDir < 0) {
    if (xPos <= left.X+left.Width/2) {
      if ((left.Y+left.Height >= yPos+ballSize) &&
          (left.Y <= yPos)) {
            xDir = -xDir;
          }
    }
  } else {
    if ((xPos >= (right.X-right.Width/2))) {
      if ((right.Y + right.Height >= yPos+ballSize) &&
          (right.Y <= yPos)) {
            xDir = -xDir;
          }
    }
  }
  
  if (xPos < left.X-left.Width/2) {
    right.score++;
    resetBall();
  }
  
  if (xPos > right.X+right.Width/2) {
    left.score++;
    resetBall();
  }
  
  if ((yPos - ballSize/2 <= 0) || (yPos + ballSize/2 >= height)) {
    yDir = -yDir;
  }
  
  xPos = xPos + xDir;
  yPos = yPos + yDir;
  
  rect(xPos, yPos, ballSize, ballSize);
}
