import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// Run this program only in the Java mode inside the IDE,
// not on Processing.js (web mode)!!
/* @pjs preload="blood1.png"; */
/* @pjs preload="blood3.png"; */
/* @pjs preload="blood2.png"; */

import processing.video.*;

PFont font;
Capture cam;
int viewWidth = 1024;
int viewHeight = 768;
int cameraWidth = viewWidth - 200;
int cameraHeight = viewHeight - 100;
int cycleDuration = 3500; // Miliseconds
int currentTime;
int initialTime;

PImage bruiseLow;
PImage bruiseMedium;
PImage bruiseHigh;

String[] introMessages = {
  "WORDS ARE POWERFUL ",
  "WORDS ARE POWERFUL,\nSEE FOR YOURSELF...",
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
  "NYMPHOMANIAC",
  "TART",
  "TRAMP",
  "SKANK",
  "HOOCHIE MAMA",
  "SEXPOT",
  "HOOKER",
  "BITCH",
  "WHORE",
  "GAME OVER"  
};

color[] highSelfSteemColors = {
  color(173,221,142),  // Light green
  color(120,198,121),
  color(65,171,93),
  color(35,132,67),
  color(0,104,55),
  color(0,69,41)       // Dark green
};

color[] lowSelfSteemColors = {
  color(252,78,42),
  color(227,26,28),
  color(189,0,38),
  color(128,0,38)    // Dark Red
};


float introInitialTime = 0;
float levelOneInitialTime = introMessages.length * cycleDuration;
float levelTwoInitialTime = levelOneInitialTime + (levelOneMessages.length * cycleDuration);
float finalTime = levelTwoInitialTime + (levelTwoMessages.length * cycleDuration);
int currentIndex = -1;
int flashCount = 0;
int flashTimer;
int flashIndex = 0;
Boolean shouldFlash = true;
Boolean shouldFlashForIndex = true;
color fontGreen = color(198, 248, 66);

void setup() {
  size(1024, 768);
  cam = new Capture(this, viewWidth, viewHeight, 24);
  cam.start();
 
  // Configure font
  font = loadFont("Extrude-32.vlw");
  textFont(font, 32);
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
  
  fill(153, 51, 250);
  rect(0, 0, viewWidth, viewHeight);
   
  pushMatrix();
  scale(-1,1);
  translate(-cam.width, 0);
  image(cam, 0, 0, cameraWidth, cameraHeight); 
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
    currentIndex = -1;
  }
}

boolean shouldPlayIntro() {
   return currentTime < levelOneInitialTime;
}

boolean shouldPlayLevelOne() {
   return levelOneInitialTime <= currentTime && currentTime < levelTwoInitialTime;
}

boolean shouldPlayLevelTwo() {
  return levelTwoInitialTime <= currentTime && currentTime < finalTime;
}

void playIntro() {
  int levelIndex = floor(currentTime/cycleDuration);
  
  if (levelIndex >= 2) {
    drawFace();
    printMiddleMessage(introMessages[levelIndex], fontGreen);
    drawSelfSteemWithLevel(0);
  }
  else {
    fill(153, 51, 250);
    rect(0, 0, viewWidth, viewHeight);
    printMiddleMessage(introMessages[levelIndex], fontGreen);
  }
  
  sayMessageForIndex(introMessages[levelIndex], levelIndex);
}

void playLevelOne() {
  int levelIndex = floor(currentTime/cycleDuration) - introMessages.length;
  
  printBottomMessage(levelOneMessages[levelIndex], fontGreen);
  sayMessageForIndex(levelOneMessages[levelIndex], levelIndex);
  
  if (levelIndex > 2 && levelIndex < levelOneMessages.length - 1) {
    drawSelfSteemWithLevel(levelIndex - 2); 
  }
  
  drawFace();
}

void playLevelTwo() {
  int levelIndex = floor(currentTime/cycleDuration) - introMessages.length - levelOneMessages.length;
  
  if (flashIndex != levelIndex) {
    flashIndex = levelIndex;
    flashCount = 0; 
  } 
  if (levelIndex > 0 && levelIndex < levelTwoMessages.length - 1) {
    drawSelfSteemWithLevel(7 - levelIndex); 
  }
  
  // Add Buises
  if (levelIndex > 8 && levelIndex < levelTwoMessages.length - 1) {
    tint(255, 50);
    image(bruiseLow, (viewWidth / 2) + 30, (viewHeight/2) + 20, 100, 150);
    tint(255);
  }
  
  if (levelIndex > 9 && levelIndex < levelTwoMessages.length - 1) {
    tint(255, 50);
    image(bruiseHigh, (viewWidth / 2) - 150, (viewHeight/2) + 30, 130, 100);
    tint(255);
  }
  
  if (levelIndex > 10 && levelIndex < levelTwoMessages.length - 1) {
    tint(255, 120);
    image(bruiseHigh, (viewWidth / 2) - 30, (viewHeight/2) - 90, 170, 150);
    tint(255);
  }
  
  if (levelIndex < levelTwoMessages.length - 1) {
    printBottomMessage(levelTwoMessages[levelIndex], fontGreen);
    drawFace(); 
  }
  else {
     printMiddleMessage(levelTwoMessages[levelIndex], fontGreen); 
  }
  
  if (levelIndex > 8 && levelIndex < levelTwoMessages.length - 1) {
     flashWarning(levelIndex - 7);
  }
  sayMessageForIndex(levelTwoMessages[levelIndex], levelIndex);
}

void printMiddleMessage(String message, color messageColor) {
  textSize(32);
  fill(messageColor);
  text(message, 0, (viewHeight/2) - 40, viewWidth, 80);
}

void printBottomMessage(String message, color messageColor) {
  textSize(32);
  fill(messageColor);
  text(message, 0, viewHeight - 80, viewWidth, viewHeight);
}

void sayMessageForIndex(String message, int index) {
  if (index == currentIndex) { return; }

  currentIndex = index;
  TextToSpeech.say(message);  
}

void drawFace() {
  noFill();
  ellipse(viewWidth/2, viewHeight/2, 250, 400); 
}

void drawSelfSteemWithLevel(int level) {
  fill(114, 247, 154 );
  textSize(26);
  int originHeight = (viewHeight/4);
  text("SELF-ESTEEM LEVEL\n...............", 0, originHeight, 200, viewHeight);
  
  if (level > 0) {
    for (int i = 0; i < level; i++) {
      fill(highSelfSteemColors[i]);
      rect(50, ((5 - i) * 35) + (viewHeight/4) + 100, 100, 30);
    }
  }
  else {
    for (int i = 0; i < abs(level); i++) {
      fill(lowSelfSteemColors[i]);
      rect(50, (i * 35) + (viewHeight/4) + 310, 100, 30);
    }
  }
}

void flashWarning(int times) {
  if (flashCount == times) {
    flashTimer = 0;
    shouldFlash = true;
    return;
  }
  
  if (flashTimer == 0) {
    flashTimer = millis(); 
  }
  
  if (shouldFlash) {
    fill(color(189, 0, 38));
    rect(0, 0, viewWidth, viewHeight);
  }
  
  if (millis() - flashTimer > 200) {
    flashCount++;
    flashTimer = millis();
    shouldFlash = !shouldFlash;
  }
}

// the text to speech class
import java.io.IOException;

static class TextToSpeech extends Object {

  // Store the voices, makes for nice auto-complete in Eclipse

  // male voices
  static final String ALEX = "Alex";
  static final String BRUCE = "Bruce";
  static final String FRED = "Fred";
  static final String JUNIOR = "Junior";
  static final String RALPH = "Ralph";

  // female voices
  static final String AGNES = "Agnes";
  static final String KATHY = "Kathy";
  static final String PRINCESS = "Princess";
  static final String VICKI = "Vicki";
  static final String VICTORIA = "Victoria";

  // throw them in an array so we can iterate over them / pick at random
  static String[] voices = {
    ALEX, BRUCE, FRED, JUNIOR, RALPH, AGNES, KATHY,
    PRINCESS, VICKI, VICTORIA
  };

  // this sends the "say" command to the terminal with the appropriate args
  static void say(String script, String voice, int speed) {
    try {
      Runtime.getRuntime().exec(new String[] {"say", "-v", voice, "[[rate " + speed + "]]" + script});
    }
    catch (IOException e) {
      System.err.println("IOException");
    }
  }

  // Overload the say method so we can call it with fewer arguments and basic defaults
  static void say(String script) {
    // 200 seems like a resonable default speed
    say(script, VICKI, 270);
  }

}
