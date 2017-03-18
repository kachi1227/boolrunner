abstract class BaseGameScreen {

  float speed = 14; //suggested max of 13
  int groundLevel;


  ArrayList<Snow> snowflakes = new ArrayList<Snow>();
  
  ScreenChangeDelegate delegate;

  private PFont titleFont;
  private PFont mainFont;

  BaseGameScreen(ScreenChangeDelegate delegate) {
    this.delegate = delegate;
    groundLevel = height - 100;
    //Setting up background
    for (int snow = 0; snow < 70; snow++) {
      Snow snowflake = new Snow(random(0, 1200), random(-200, -10));
      snowflakes.add(snowflake);
    }

    titleFont = loadFont("Phosphate-Inline-48.vlw");
    mainFont = loadFont("Avenir-Roman-48.vlw");
  }

  void drawBackground() {
    noStroke();

    //ground
    fill(255);
    rect(0, groundLevel, width, 100);

    //sky
    fill(135, 206, 235);
    rect(0, 0, width, height - 100);

    drawSnow();
  }



  private void drawSnow() {
    fill(255, 255, 255, 170);
    //ellipse(250, 250, 20, 20);
    for (Snow s : snowflakes) {
      s.xPos -= 0.25;
      s.yPos++;
      ellipse(s.xPos, s.yPos, 10, 10);
      if (s.xPos < 0 || s.yPos > 500) {
        s.xPos = random(0, 900);
        s.yPos = random(-200, -10);
      }
    }
  }

  void reset(Map<String, Object> gameStateValues) {
    
  }

  boolean handleKeyPressed() {
    if (key == 'q') {
      delegate.restart();
      return true;
    }
    return false;
  }

  boolean handleMouseClicked() {
    return false;
  }
  
  boolean handleMouseMoved() {
   return false; 
  }


  PFont getTitleFont() {
    return titleFont;
  }

  PFont getMainFont() {
    return mainFont;
  }




  abstract void drawScreen();
}