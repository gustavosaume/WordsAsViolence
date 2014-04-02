import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Thesis extends PApplet {

// Run this program only in the Java mode inside the IDE,
// not on Processing.js (web mode)!!



PFont font;
Capture cam;
int viewWidth = 1024;
int viewHeight = 720;
int cycleDuration = 2000; // Miliseconds
int currentTime;
int initialTime;

PImage bruiseLow;
PImage bruiseMedium;
PImage bruiseHigh;

String[] introMessages = {
  "WORDS ARE A FORM OF VIOLENCE, SEE FOR YOURSELF...",
  "PLACE FACE",
  "PLAY"
};

String[] levelOneMessages = {
  "LEVEL 1",
  "A MAN WHO HAS LOTS OF SEX IS CALLED...",
  "SAY WITH ME",
  "STUD",
  "PLAYER",
  "STALLION",
  "ROMEO",
  "CASANOVA",
  "DON JUAN",
  "CONGRATULATIONS"
};

String[] levelTwoMessages = {
  "LEVEL 2",
  "A WOMAN THAT HAS LOTS OF SEX IS CALLED...",
  "SLUT",
  "NYMPHO",
  "TART",
  "HUSTLER",
  "SEXPOT",
  "HOOKER",
  "BITCH",
  "WHORE",
  "GAME OVER"  
};

float introInitialTime = 0;
float levelOneInitialTime = introMessages.length * cycleDuration;
float levelTwoInitialTime = levelOneInitialTime + (levelOneMessages.length * cycleDuration);
float finalTime = levelTwoInitialTime + (levelTwoMessages.length * cycleDuration);

public void setup() {
  size(viewWidth, viewHeight);
  cam = new Capture(this, viewWidth, viewHeight, 24);
  cam.start();
 
  // Configure font
  font = createFont("Extrude.ttf", 32);
  textAlign(CENTER);
  
  bruiseLow = loadImage("blood 2.png");
  bruiseMedium = loadImage("blood 1.png");
  bruiseHigh = loadImage("blood 3.png");
  
  initialTime = millis();
}

public void draw() {
  if(cam.available()) {
    cam.read();
  }
  
  image(cam, 0, 0, viewWidth, viewHeight);
  
  currentTime = millis() - initialTime;
  
  if (shouldPlayIntro()) {
    playIntro();
  }
  else if (shouldPlayLevelOne()) {
    playLevelOne();
  }
  else if (shouldPlayLevelTwo()) {
    playLevelTwo();
  }
  else {
    // Reset the timer 
    initialTime = millis();
  }
}

public boolean shouldPlayIntro() {
   return currentTime < levelOneInitialTime;
}

public boolean shouldPlayLevelOne() {
   return levelOneInitialTime < currentTime && currentTime < levelTwoInitialTime;
}

public boolean shouldPlayLevelTwo() {
  return levelTwoInitialTime < currentTime && currentTime < finalTime;
}

public void playIntro() {
  int levelIndex = floor((currentTime/2)/1000);
  printMiddleMessage(introMessages[levelIndex]);
  
  if (levelIndex > 0) {
    drawFace();
  }
}

public void playLevelOne() {
  int levelIndex = floor((currentTime/2)/1000) - introMessages.length;
  printBottomMessage(levelOneMessages[levelIndex]);
  
  if (levelIndex > 2 && levelIndex < levelOneMessages.length - 1) {
    drawSelfSteemWithLevel(levelIndex - 2); 
  }
  
  drawFace();
}

public void playLevelTwo() {
  int levelIndex = floor((currentTime/2)/1000) - introMessages.length - levelOneMessages.length;
  
  
  if (levelIndex > 0 && levelIndex < levelTwoMessages.length - 1) {
    drawSelfSteemWithLevel(7 - levelIndex); 
  }
  
  // Add Buises
  if (levelIndex > 6 && levelIndex < levelTwoMessages.length - 1) {
    image(bruiseLow, (viewWidth / 2) + 30, (viewHeight/2), 100, 150);
  }
  
  if (levelIndex > 7 && levelIndex < levelTwoMessages.length - 1) {
    tint(255, 80);
    image(bruiseHigh, (viewWidth / 2) - 150, (viewHeight/2) - 100, 200, 170);
    tint(255);
  }
  
  if (levelIndex > 8 && levelIndex < levelTwoMessages.length - 1) {
    tint(255, 120);
    image(bruiseHigh, (viewWidth / 2) - 30, (viewHeight/2) - 100, 200, 170);
    tint(255);
  }
  
  if (levelIndex < levelTwoMessages.length - 1) {
    printBottomMessage(levelTwoMessages[levelIndex]);
    drawFace(); 
  }
  else {
     printMiddleMessage(levelTwoMessages[levelIndex]); 
  }
}

public void printMiddleMessage(String message) {
  textSize(32);
  fill(255);
  text(message, 0, (viewHeight/2) - 40, viewWidth, 80); 
}

public void printBottomMessage(String message) {
  textSize(32);
  fill(255);
  text(message, 0, viewHeight - 80, viewWidth, viewHeight);
}

public void drawFace() {
  noFill();
  ellipse(viewWidth/2, viewHeight/2, 250, 400); 
}

public void drawSelfSteemWithLevel(int level) {
  fill(255);
  textSize(26);
  int originHeight = (viewHeight/4);
  text("SELF-ESTEEM LEVEL", 0, originHeight, 200, viewHeight);
  
  if (level > 0) {
    fill(0, 255, 0);
    for (int i = 0; i < level; i++) {
      rect(50, ((5 - i) * 35) + (viewHeight/4) + 100, 100, 30);
    }
  }
  else {
    fill(255, 0, 0);
    for (int i = 0; i < abs(level); i++) {
      rect(50, (i * 35) + (viewHeight/4) + 310, 100, 30);
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "Thesis" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
