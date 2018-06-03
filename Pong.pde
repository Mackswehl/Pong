import processing.sound.*;

boolean start; // start of game state
boolean firstName; // entering first names state
boolean firstColor; // entering first names color
boolean secondName; // entering second names state
boolean secondColor; // entering second names color
boolean game; // playing game state
boolean moving; // pauses ball after every score
boolean win; // win state

boolean leftUp; // Determine the movements of the paddles
boolean leftDown;
boolean rightUp;
boolean rightDown;

SoundFile bounceSound;
SoundFile paddleSound;
SoundFile scoreSound;

PFont bit8; // some of the fonts used
PFont normal;

String nameL; // names of the two players
String nameR;
final String ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

color leftColor;
color rightColor;
color ballColor;

int scoreL; // scoreboard vars for score, maxScore, and dimensions
int scoreR;
int maxScore;
int sbWidth;
int sbHeight;

float paddleW; // dimensions of paddles
float paddleH;

float paddleLX; // coordinates of the paddles
float paddleLY;
float paddleRX;
float paddleRY;

float radius = 10; 
float ballX; // coordinates of the ball
float ballY;

float paddleSpeed; // vertical speed of paddle
float ballVx; // horizaontal speed of ball
float ballVy; // vertical speed of ball
float bDirX; // ball's horizontal direction of motion
float bDirY; // ball's vertical direction of motion


void setup() {
  size (1000, 800);
  background(0);

  // setting the initial states of the game
  start = true; // start state is true while everything else is false (or off, technically)
  firstName = false;
  secondName = false;
  game = false;
  moving = false;
  win = false;
  
  bounceSound = new SoundFile(this, "ping_pong_8bit_plop.wav");
  paddleSound = new SoundFile(this, "ping_pong_8bit_beeep.wav");
  scoreSound = new SoundFile(this, "ping_pong_8bit_peeeeeep.wav");
  bit8 = createFont("8-BIT WONDER.TTF", 32); // setting up the fonts to be used
  normal = createFont("Arial", 32);

  nameL = ""; // hard-coded names --> ALLOW USER INPUT
  nameR = "";

  leftColor = color(255);
  rightColor = color(255);
  ballColor = color(255);

  scoreL = 0; 
  scoreR = 0;
  maxScore = 10;
  sbWidth = width;
  sbHeight = 50;

  paddleW = 20;
  paddleH = 75;

  paddleLX = 50;
  paddleLY = height/2;
  paddleRX = width - 50;
  paddleRY = height/2;

  radius = 10;
  ballX = width / 2;
  ballY = height / 2;

  paddleSpeed = 8;
  ballVx = 8;
  ballVy = 8;
  if (random(1) < 0.5) { // setting the ball's direction of motion to left/right and up/down
    bDirX = 1;
  } else {
    bDirX = -1;
  }
  if (random(1) < 0.5) {
    bDirY = 1;
  } else {
    bDirY = -1;
  }
}

void draw() {
  if (start) {
    startScreen();
  } else if (firstName) {
    enterFirst();
  } else if (firstColor || secondColor) {
    chooseColor();
  } else if (secondName) {
    enterSecond();
  } else if (game) {
    background(0);
    line(width/2, 0, width/2, height);
    scoreboard();
    paddles();
    movePaddles();
    ball();
    if (moving) {
      moveBall();
    }
  } else if (win) {
    winScreen();
  }
}

// draws a start screen
void startScreen() {
  background(0);
  fill(255);
  textFont(bit8);
  textSize(75);
  textAlign(CENTER);
  text("PONG", width/2, height/2);
  textSize(15);
  text("Press SPACE to start", width/2, height/2 + 50);
}

void enterFirst() {
  background(0);
  fill(255);
  text("Enter Player One Name", width/2, height/2 - 50);
  text(nameL, width/2, height/2);
}

void enterSecond() {
  background(0);
  fill(255);
  text("Enter Player Two Name", width/2, height/2 - 50);
  text(nameR, width/2, height/2);
}

void chooseColor() {
  background(0);
  fill(255);
  text("Choose Color", width/2, height/2 - 100);
  rectMode(CENTER);

  // red
  if (mouseIn(width/2 - 300, height/2, 50, 50)) {
    fill(255, 0, 0, 100);
  } else {
    fill(255, 0, 0);
  }
  rect(width/2 - 300, height/2, 50, 50);

  // orange
  if (mouseIn(width/2 - 200, height/2, 50, 50)) {
    fill(255, 127, 0, 100);
  } else {
    fill(255, 127, 0);
  }
  rect(width/2 - 200, height/2, 50, 50);

  // yellow
  if (mouseIn(width/2 - 100, height/2, 50, 50)) {
    fill(255, 255, 0, 100);
  } else {
    fill(255, 255, 0);
  }
  rect(width/2 - 100, height/2, 50, 50);

  // green
  if (mouseIn(width/2, height/2, 50, 50)) {
    fill(0, 255, 0, 100);
  } else {
    fill(0, 255, 0);
  }
  rect(width/2, height/2, 50, 50);

  // blue 
  if (mouseIn(width/2 + 100, height/2, 50, 50)) {
    fill(0, 0, 255, 100);
  } else {
    fill(0, 0, 255);
  }
  rect(width/2 + 100, height/2, 50, 50);

  // indigo
  if (mouseIn(width/2 + 200, height/2, 50, 50)) {
    fill(127, 0, 255, 100);
  } else {
    fill(127, 0, 255);
  }
  rect(width/2 + 200, height/2, 50, 50);

  // violet
  if (mouseIn(width/2 + 300, height/2, 50, 50)) {
    fill(255, 0, 255, 100);
  } else {
    fill(255, 0, 255);
  }
  rect(width/2 + 300, height/2, 50, 50);
}

boolean mouseIn(float xcor, float ycor, float w, float h) {
  if (mouseX >= xcor - w/2 && mouseX <= xcor + w/2 && mouseY >= ycor - h/2 && mouseY <= ycor + h/2) {
    return true;
  }
  return false;
}

// draws a win screen
void winScreen() {
  background(0);
  textFont(bit8);
  textSize(50);
  textAlign(CENTER);
  if (scoreL == maxScore) {
    fill(leftColor);
    text(nameL + " wins", width/2, height/2);
  } else {
    fill(rightColor);
    text(nameR + " wins", width/2, height/2);
  }
}

// draws a scoreboard area with scores on the game screen
void scoreboard() {
  fill(200);
  rectMode(CORNER);
  rect(0, 0, sbWidth, sbHeight);
  textFont(normal);
  textAlign(CENTER);
  fill(leftColor);
  text(nameL + ": " + scoreL, width/4, 3 * sbHeight / 4);
  fill(rightColor);
  text(nameR + ": " + scoreR, 3 * width / 4, 3 * sbHeight / 4);
}

// drawing ball
void ball() {
  fill(ballColor);
  ellipseMode(RADIUS);
  ellipse(ballX, ballY, radius, radius);
}

// moving the ball, including collision behavior
void moveBall() {

  // if ball hits the right edge of the left paddle
  if (ballX >= paddleLX + paddleW/2 && ballX <= paddleLX + paddleW/2 + radius && ballY > paddleLY - paddleH/2 - radius && ballY < paddleLY + paddleH/2 + radius) {
    bDirX *= -1;
    
    // incrementally increases the speed of the ball after each hit
    ballVx *= 1.05;
    
    paddleSound.play();
    ballColor = leftColor;
  } else if (ballX <= paddleLX + paddleW/2 + radius && ballX >= paddleLX - paddleW/2 - radius) { // bounces off the top and bottom of the left paddle
    if (ballY <= paddleLY + paddleH/2 + radius && ballY > paddleLY + paddleH/2) {
      bDirY *= -1;
      ballY = paddleLY + paddleH/2 + radius + ballVy * bDirY;
      paddleSound.play();
    }
    if (ballY >= paddleLY - paddleH/2 - radius && ballY < paddleLY - paddleH/2) {
      bDirY *= -1;
      ballY = paddleLY - paddleH/2 - radius + ballVy * bDirY;
      paddleSound.play();
    }
  }

  // if ball hits the left edge of the right paddle
  if (ballX <= paddleRX - paddleW/2 && ballX >= paddleRX - paddleW/2 - radius && ballY > paddleRY - paddleH/2 - radius && ballY < paddleRY + paddleH/2 + radius ) {
    bDirX *= -1;
    
    // incrementally increases the speed of the ball after each hit
    ballVx *= 1.05;
    
    paddleSound.play();
    ballColor = rightColor;
  } else if (ballX <= paddleRX + paddleW/2 + radius && ballX >= paddleRX - paddleW/2 - radius) {  // bounces off the top and bottom of the right paddle
    if (ballY <= paddleRY + paddleH/2 + radius && ballY > paddleRY + paddleH/2) {
      bDirY *= -1;
      ballY = paddleRY + paddleH/2 + radius + ballVy * bDirY;
      paddleSound.play();
    }
    if (ballY >= paddleRY - paddleH/2 - radius && ballY < paddleRY - paddleH/2) {
      bDirY *= -1;
      ballY = paddleRY - paddleH/2 - radius + ballVy * bDirY;
      paddleSound.play();
    }
  }

  // if the ball hits the top or bottom of play area
  if (ballY >= height - radius || ballY <= radius + sbHeight) {
    bDirY *= -1;
    bounceSound.play();
  }
  
  // if reach right/left edge of screen
  if (ballX >= width - radius || ballX <= radius) {
    ballColor = color(255);
    
    // increments the score if the ball reaches the left/right edge of the screen
    if (ballX >= width - radius) {
      scoreL++;
      scoreSound.play();
      ballX = paddleRX - 100;
      ballY = random(height/2 - 200, height/2 + 200);
    } else {
      scoreR++;
      scoreSound.play();
      ballX = paddleLX + 100;
      ballY = random(height/2 - 200, height/2 + 200);
    }
    
    ballVx = 8;
    
    bDirX *= -1;
    if (random(1) < 0.5) {
      bDirY = 1;
    } else {
      bDirY = -1;
    }
    
    moving = false;
    // change state if maxScore is reached
    if (scoreL == maxScore || scoreR == maxScore) {
      game = false;
      win = true;
    }
  }

  // changing the coordinates of the ball (actually moving it)
  ballX += ballVx * bDirX;
  ballY += ballVy * bDirY;
}

// draws the two paddles onto the screen
void paddles() {
  rectMode(CENTER);
  fill(leftColor);
  rect(paddleLX, paddleLY, paddleW, paddleH);
  rectMode(CENTER);
  fill(rightColor);
  rect(paddleRX, paddleRY, paddleW, paddleH);
}

// moves the paddles depending on the button that is pressed
void movePaddles() {

  if (leftUp) {
    paddleLY -= paddleSpeed;
  }
  if (leftDown) {
    paddleLY += paddleSpeed;
  }
  if (rightUp) {
    paddleRY -= paddleSpeed;
  }
  if (rightDown) {
    paddleRY += paddleSpeed;
  }
  // limiting the bounds of the paddles to the edge of the screen
  if (paddleLY < paddleH/2 + sbHeight) {
    paddleLY = paddleH/2 + sbHeight;
  }
  if (paddleRY < paddleH/2 + sbHeight) {
    paddleRY = paddleH/2 + sbHeight;
  }
  if (paddleLY > height - paddleH/2) {
    paddleLY = height - paddleH/2;
  }
  if (paddleRY > height - paddleH/2) {
    paddleRY = height - paddleH/2;
  }
}


void keyPressed() {
  // left paddle uses w and s to move up and down
  if (key == 'w' || key == 'W') {
    leftUp = true;
  }
  if (key == 's' || key == 'S') {
    leftDown = true;
  }
  // right paddle uses up and down arror key to move up and down
  if (keyCode == UP) {
    rightUp = true;
  }
  if (keyCode == DOWN) {
    rightDown = true;
  }
  // space pressed to leave start screen and begin game
  if (key == ' ' && start) {
    start = false;
    firstName = true;
  }
  // space pressed to start the ball moving after every score
  if (key == ' ' && game) {
    moving = true;
  }

  // entering player one's name
  if (firstName) {
    if (nameL.length() > 0 && keyCode == BACKSPACE) {
      nameL = nameL.substring(0, nameL.length() - 1);
    } else if (nameL.length() < 10 && ALPHABET.indexOf(key) != -1) {
      nameL += key;
    } else if (key == '1') {
      firstName = false;
      firstColor = true;
    }
  }

  // entering player two's name
  if (secondName) {
    if (nameR.length() > 0 && keyCode == BACKSPACE) {
      nameR = nameR.substring(0, nameR.length() - 1);
    } else if (nameR.length() < 10 && ALPHABET.indexOf(key) != -1) {
      nameR += key;
    } else if (key == '2') {
      secondName = false;
      secondColor = true;
    }
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    leftUp = false;
  }
  if (key == 's' || key == 'S') {
    leftDown = false;
  }
  if (keyCode == UP) {
    rightUp = false;
  }
  if (keyCode == DOWN) {
    rightDown = false;
  }
}

void mouseClicked() {
  if (firstColor) {
    if (mouseIn(width/2 - 300, height/2, 50, 50)) {
      leftColor = color(255, 0, 0);
    }
    if (mouseIn(width/2 - 200, height/2, 50, 50)) {
      leftColor = color(255, 127, 0);
    }
    if (mouseIn(width/2 - 100, height/2, 50, 50)) {
      leftColor = color(255, 255, 0);
    }
    if (mouseIn(width/2, height/2, 50, 50)) {
      leftColor = color(0, 255, 0);
    }
    if (mouseIn(width/2 + 100, height/2, 50, 50)) {
      leftColor = color(0, 0, 255);
    }
    if (mouseIn(width/2 + 200, height/2, 50, 50)) {
      leftColor = color(127, 0, 255);
    }
    if (mouseIn(width/2 + 300, height/2, 50, 50)) {
      leftColor = color(255, 0, 255);
    }
    firstColor = false;
    secondName = true;
  }


  if (secondColor) {
    if (mouseIn(width/2 - 300, height/2, 50, 50)) {
      rightColor = color(255, 0, 0);
    }
    if (mouseIn(width/2 - 200, height/2, 50, 50)) {
      rightColor = color(255, 127, 0);
    }
    if (mouseIn(width/2 - 100, height/2, 50, 50)) {
      rightColor = color(255, 255, 0);
    }
    if (mouseIn(width/2, height/2, 50, 50)) {
      rightColor = color(0, 255, 0);
    }
    if (mouseIn(width/2 + 100, height/2, 50, 50)) {
      rightColor = color(0, 0, 255);
    }
    if (mouseIn(width/2 + 200, height/2, 50, 50)) {
      rightColor = color(127, 0, 255);
    }
    if (mouseIn(width/2 + 300, height/2, 50, 50)) {
      rightColor = color(255, 0, 255);
    }
    secondColor = false;
    game = true;
  }
}
