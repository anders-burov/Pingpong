/* This sketch receives sensor values from the board
   and visualizes them as ping pong game.
   Use R key to restart and P to pause.
*/

import processing.serial.*;
import processing.net.*;

int linefeed = 10;
//Serial port;
Client client;
int eth_port = 5555;

float leftPaddle, rightPaddle;
int leftPaddleX, rightPaddleX;
int paddleHeight = 50;
int paddleWidth = 10;
float leftMin = 410;
float leftMax = 620;
float rightMin = 401;
float rightMax = 614;
float leftRange = 0;
float rightRange = 0;

boolean paused = false;

int ballSize = 10;
int xDir = 1; // left -1, right 1
int yDir = 1; // up -1, down 1
int xPos, yPos;

int leftScore = 0;
int rightScore = 0;

PFont font;
int fontSize = 36;

boolean madeContact = false;

void setup() {
  size(640, 480);
  
  //println(Serial.list());
  //port = new Serial(this, Serial.list()[0], 9600);
  // linfeed would signalize handling the buffer in serialEvent
  //port.bufferUntil(linefeed);
  try {
    println("Connect to server");
    client = new Client(this, "192.168.5.10", eth_port);
    client.write("hello\n");
    println("Connection established " + client);
  } catch (RuntimeException e) {   
    e.printStackTrace();
  }
  
  leftPaddle = height/2;
  rightPaddle = height/2;
  
  leftPaddleX = 50;
  rightPaddleX = width-50;
  
  leftRange = leftMax - leftMin;
  rightRange = rightMax - rightMin;
  
  resetBall();
  println("Font?");
  font = createFont(PFont.list()[2], fontSize);
  textFont(font);
  
  noStroke();
  println("Setup configured");
}

void draw() {
  background(0);
  rect(leftPaddleX, leftPaddle, paddleWidth, paddleHeight);
  rect(rightPaddleX, rightPaddle, paddleWidth, paddleHeight);
  if (paused == false) {
    animateBall();
  } else {
    textAlign(CENTER);
    text("PRESS P TO PLAY", width/2, height/2);
    rect(xPos, yPos, ballSize, ballSize);
  }
  textAlign(CENTER, TOP);
  text(leftScore, fontSize, fontSize);
  text(rightScore, width-fontSize, fontSize);
  //client.write("hello\n");
}

void clientEvent(Client client) {
  try {
  String string = client.readStringUntil(linefeed);
  
  if (string != null) {
    string = trim(string);
    if (madeContact == false) {
      if (string.equals("hello")) {
        client.clear();
        madeContact = true;
        client.write('\r');
      }
    }
  }
    
  int sensors[] = int(split(string, ','));
    
  if (sensors.length == 2) {
    leftPaddle = map(sensors[0], leftMin, leftMax, 0, height);
    rightPaddle = map(sensors[1], rightMin, rightMax, 0, height);
      
    if (paused == false) {
      println("X = " + leftPaddle + ", Y = " + rightPaddle);
      //println("Xp = " + xPos + ", Yp = " + yPos);
    }
      
    client.write('\r');
  }
  } catch (RuntimeException e) {
    e.printStackTrace();
  }
}

void keyPressed() {
  if (key == 'r') {
    paused = true;
    leftScore = 0;
    rightScore = 0;
    resetBall();
  }
  if (key == 'p') {
    paused = !paused;
    println("P PRESSED");
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
  /*if (xDir < 0) {
    if (xPos <= leftPaddleX+paddleWidth/2) {
      if ((leftPaddle-(paddleHeight/2) <= yPos+ballSize/2) &&
          (leftPaddle+(paddleHeight/2) >= yPos)) {
            xDir = -xDir;
          }
    }
  } else {
    if ((xPos >= (rightPaddleX-paddleWidth/2))) {
      if ((rightPaddle - (paddleHeight/2) <= yPos+ballSize/2) &&
          (rightPaddle + (paddleHeight/2) >= yPos+ballSize)) {
            xDir = -xDir;
          }
    }
  }*/
  if (xDir < 0) {
    if (xPos <= leftPaddleX+paddleWidth/2) {
      if ((leftPaddle+paddleHeight >= yPos+ballSize) &&
          (leftPaddle <= yPos)) {
            xDir = -xDir;
          }
    }
  } else {
    if ((xPos >= (rightPaddleX-paddleWidth/2))) {
      if ((rightPaddle + paddleHeight >= yPos+ballSize) &&
          (rightPaddle <= yPos)) {
            xDir = -xDir;
          }
    }
  }
  
  if (xPos < 0) {
    rightScore++;
    resetBall();
  }
  
  if (xPos > width) {
    leftScore++;
    resetBall();
  }
  
  if ((yPos - ballSize/2 <= 0) || (yPos + ballSize/2 >= height)) {
    yDir = -yDir;
  }
  
  xPos = xPos + xDir;
  yPos = yPos + yDir;
  
  rect(xPos, yPos, ballSize, ballSize);
}
