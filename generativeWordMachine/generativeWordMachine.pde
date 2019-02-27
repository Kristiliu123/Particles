// CFI - Drawing Machines - Giggles, Joan

// GENERATIVE WORD MACHINE 

String jgText = "MAKE";
float jgTextSize = 250;

PGraphics jgPGraphic; // This variable holds image data for the letter
PFont jgFont; // This variable holds font data for the letter
ArrayList<jgModuleClass> jgModuleClassList; // This is a list of all of the individual Modules you create

int jgUnit = 5; // CHANGE THIS to adjust spacing between your modules


color jgPGraphicBackgroundColor = color(255); // CHANGE THIS to adjust background color in your PGraphic
color jgPGraphicTypeColor = color(100); // CHANGE THIS to adjust letter color in your PGraphic
color jgModuleColor = color(0); // CHANGE THIS to adjust letter color

float jgEasingSlow = 0.025; // CHANGE THIS to adjust the speed of jgEasingSlow
float jgEasingFast = 0.05; // CHANGE THIS to adjust the speed of jgEasingFast
float jgVelocity = .5; // CHANGE THIS to adjust default module velocity

float jgScaleMin = 5; // CHANGE THIS to adjust default minimum module scale
float jgScaleMax = 25; // CHANGE THIS to adjust default maximum module scale

float distanceToMouse;

void setup() {
  size(960, 540); // jg changed the size to half hd
  // this chunk of code creates a simple graphic of a single letter on a background
  // the image it will not be visible, but it's pixel data will be used to drive the 
  // behavior of the "jgModules" you create
  jgPGraphic = createGraphics(width, height);
  jgFont = createFont("Helvetica-Bold", jgTextSize);
  jgPGraphic.beginDraw();
  jgPGraphic.background(jgPGraphicBackgroundColor);
  jgPGraphic.noStroke();
  jgPGraphic.fill(jgPGraphicTypeColor);
  jgPGraphic.textAlign(CENTER, CENTER);
  //jgPGraphic.textSize(jgTextSize);
  jgPGraphic.textFont(jgFont);
  jgPGraphic.text(jgText, jgPGraphic.width/2, jgPGraphic.height/2-20); 
  jgPGraphic.endDraw();

  noStroke();
  int jgWideCount = width / jgUnit;
  int jgHighCount = height / jgUnit;
  jgModuleClassList = new ArrayList<jgModuleClass>(); // Initialize the arraylist

  for (int y = 0; y < jgHighCount; y++) {
    for (int x = 0; x < jgWideCount; x++) {

      color checkColor = jgPGraphic.get(x*jgUnit, y*jgUnit);
      if (checkColor == jgPGraphicTypeColor) { 
        jgModuleClassList.add(new jgModuleClass(x*jgUnit, y*jgUnit));
      }
    }
  }
}

void draw() {
  background(255);// UNCOMMENT this line to clear your image every frame
  //image(jgPGraphic,0,0);  UNCOMMENT this line to see the PGraphic for your letter
  for (jgModuleClass mod : jgModuleClassList) {
    mod.jgModuleUpdate();
    mod.jgModuleDisplay();
  }
}


class jgModuleClass {
  float jgModuleX, jgModuleY; // you can declare multiple variables on a single line by using commas
  float jgModuleXOrigin, jgModuleYOrigin;
  float jgModuleXTarget, jgModuleYTarget;
  float jgModuleXDistance, jgModuleYDistance;
  float jgModuleXVelocity, jgModuleYVelocity;
  float jgModuleXScale, jgModuleYScale;
  float jgModuleAge;


  // Contructor - moves the particles away
  jgModuleClass(int jgXTemp, int jgYTemp) {
    jgModuleXOrigin = jgModuleX = jgXTemp;
    jgModuleYOrigin = jgModuleY = jgYTemp;
    //jgModuleXVelocity = random(-2,2);
    //jgModuleYVelocity = random(-2,2);
    //jgModuleXVelocity = random(jgVelocity)-jgVelocity*.5;
    //jgModuleYVelocity = random(jgVelocity)-jgVelocity*.5;
    jgModuleXScale = jgModuleYScale = 5;
    jgModuleAge = 0;
  }

  // Custom method for updating the variables
  void jgModuleUpdate() {
    //jgModuleRandomGray();
    jgModuleVelocity();
    jgModuleBounceInLetter();
    //jgModuleBounceOffWalls();
    //jgModulePerlinNoiseScale();
    if (jgModuleNearMouse()) jgModuleAvoidMouse(); 
    //else jgModuleGoHome(); 
    //if (jgModuleOverLetter()) jgModuleGrow(); else jgModuleShrink(); 
    //if (jgModuleOverLetter()) jgModuleColor = 0; else jgModuleColor = 255; 
    //jgSaveFrames();
    jgModuleAge++;
  }

  // Custom method for drawing the object
  void jgModuleDisplay() {
    fill(jgModuleColor);
    //ellipse(jgModuleX, jgModuleY, jgModuleXScale+=jgModuleAge*.001, jgModuleYScale);

    ellipse(jgModuleX, jgModuleY, jgModuleXScale, jgModuleYScale);
  }

  void jgModuleRandomGray() {
    jgModuleColor = int(random(255));
  }

  void jgModuleVelocity() {
    jgModuleX += jgModuleXVelocity;
    jgModuleY += jgModuleYVelocity;
  }

  void jgModulePerlinNoiseScale() {
    if (jgModuleXScale < noise(jgModuleX+millis()*.001, jgModuleY+millis()*.001)*60) jgModuleGrow();
    if (jgModuleXScale > noise(jgModuleX+millis()*.001, jgModuleY+millis()*.001)*60) jgModuleShrink();
  }

  void jgModuleGrow() {
    if (jgModuleXScale>jgScaleMax) jgModuleXScale = jgScaleMax; 
    else jgModuleXScale++;
    if (jgModuleYScale>jgScaleMax) jgModuleYScale = jgScaleMax; 
    else jgModuleYScale++;
  }

  void jgModuleShrink() {
    if (jgModuleXScale<jgScaleMin) jgModuleXScale = jgScaleMin; 
    else jgModuleXScale--;
    if (jgModuleYScale<jgScaleMin) jgModuleYScale = jgScaleMin; 
    else jgModuleYScale--;
  }

  void jgModuleBounceOffWalls() {
    if (jgModuleX >= width || jgModuleX <= 0) {
      jgModuleXVelocity *= -1;
    }
    if (jgModuleY >= height || jgModuleY <= 0) {
      jgModuleYVelocity *= -1;
    }
  }

  void jgModuleBounceInLetter() {
    if (!jgModuleOverLetter()) {
      jgModuleXVelocity *= -1;
      jgModuleYVelocity *= -1;
    }
  }

  // This function moves the Module away from the mouse 
  // if it is within a certain distance
  void jgModuleAvoidMouse() {
    jgModuleXTarget = mouseX;
    jgModuleXDistance = jgModuleXTarget - jgModuleX;
    jgModuleX -= jgModuleXDistance * jgEasingSlow;

    jgModuleYTarget = mouseY;
    jgModuleYDistance = jgModuleYTarget - jgModuleY;
    jgModuleY -= jgModuleYDistance * jgEasingSlow;
  }

  // This function moves the Module back towards it's point of orgin
  void jgModuleGoHome() {
    jgModuleXTarget = jgModuleXOrigin;
    jgModuleXDistance = jgModuleXTarget - jgModuleX;
    jgModuleX += jgModuleXDistance * jgEasingFast;

    jgModuleYTarget = jgModuleYOrigin;
    jgModuleYDistance = jgModuleYTarget - jgModuleY;
    jgModuleY += jgModuleYDistance * jgEasingFast;
  }

  // This function saves a png of the current frame. Calling this 
  // function on everyframe will give you all the frames you need 
  // to make a video using Processing's "Movie Maker"
  void jgSaveFrames() {
    saveFrame("frames/####.png");
  }

  // This function returns a Boolean value (either True or False) 
  // if the Module is over your letter it will return True, otherwise false
  Boolean jgModuleOverLetter() {
    color checkColor = jgPGraphic.get(int(jgModuleX), int(jgModuleY));
    //println("checkColor = " + checkColor + "jgPGraphicTypeColor = " + jgPGraphicTypeColor);
    if (checkColor == jgPGraphicTypeColor) {
      return true;
    } else {
      return false;
    }
  }

  Boolean jgModuleNearMouse() {
    distanceToMouse = dist(jgModuleX, jgModuleY, mouseX, mouseY);
    if (distanceToMouse < 30) {
      return true;
    } else {
      return false;
    }
  }
}
