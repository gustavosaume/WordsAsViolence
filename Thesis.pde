// Run this program only in the Java mode inside the IDE,
// not on Processing.js (web mode)!!
/* @pjs preload="blood1.png"; */
/* @pjs preload="blood3.png"; */
/* @pjs preload="blood2.png"; */

import processing.video.*;

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

void setup() {
  size(viewWidth, viewHeight);
  cam = new Capture(this, viewWidth, viewHeight, 24);
  cam.start();
 
  // Configure font
  font = createFont("Extrude.ttf", 32);
  textAlign(CENTER);
  
  bruiseLow = loadImage("blood2.png");
  bruiseMedium = loadImage("blood1.png");
  bruiseHigh = loadImage("blood3.png");
  
  initialTime = millis();
}

void draw() {
  if(cam.available()) {
    cam.read();
  }
  
  pushMatrix();
  scale(-1,1);
  translate(-cam.width, 0);
  image(cam, 0, 0, viewWidth, viewHeight); 
  popMatrix();
  
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

boolean shouldPlayIntro() {
   return currentTime <= levelOneInitialTime;
}

boolean shouldPlayLevelOne() {
   return levelOneInitialTime <= currentTime && currentTime < levelTwoInitialTime;
}

boolean shouldPlayLevelTwo() {
  return levelTwoInitialTime <= currentTime && currentTime < finalTime;
}

void playIntro() {
  int levelIndex = floor((currentTime/2)/1000);
  printMiddleMessage(introMessages[levelIndex]);
  
  if (levelIndex > 0) {
    drawFace();
  }
}

void playLevelOne() {
  int levelIndex = floor((currentTime/2)/1000) - introMessages.length;
  printBottomMessage(levelOneMessages[levelIndex]);
  
  if (levelIndex > 2 && levelIndex < levelOneMessages.length - 1) {
    drawSelfSteemWithLevel(levelIndex - 2); 
  }
  
  drawFace();
}

void playLevelTwo() {
  int levelIndex = floor((currentTime/2)/1000) - introMessages.length - levelOneMessages.length;
  
  
  if (levelIndex > 0 && levelIndex < levelTwoMessages.length - 1) {
    drawSelfSteemWithLevel(7 - levelIndex); 
  }
  
  // Add Buises
  if (levelIndex > 6 && levelIndex < levelTwoMessages.length - 1) {
    tint(255, 50);
    image(bruiseLow, (viewWidth / 2) + 30, (viewHeight/2) + 20, 100, 150);
    tint(255);
  }
  
  if (levelIndex > 7 && levelIndex < levelTwoMessages.length - 1) {
    tint(255, 50);
    image(bruiseHigh, (viewWidth / 2) - 150, (viewHeight/2) + 30, 130, 100);
    tint(255);
  }
  
  if (levelIndex > 8 && levelIndex < levelTwoMessages.length - 1) {
    tint(255, 120);
    image(bruiseHigh, (viewWidth / 2) - 30, (viewHeight/2) - 90, 170, 150);
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

void printMiddleMessage(String message) {
  textSize(32);
  fill(255);
  text(message, 0, (viewHeight/2) - 40, viewWidth, 80); 
}

void printBottomMessage(String message) {
  textSize(32);
  fill(255);
  text(message, 0, viewHeight - 80, viewWidth, viewHeight);
}

void drawFace() {
  noFill();
  ellipse(viewWidth/2, viewHeight/2, 250, 400); 
}

void drawSelfSteemWithLevel(int level) {
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
