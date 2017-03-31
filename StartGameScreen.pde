class StartGameScreen extends BaseGameScreen {

  private final float BUTTON_WIDTH = 170;
  private final float BUTTON_HEIGHT = 60;
  
  private final float INSTRUCTIONS_AREA_LEFT = width * .1;
  private final float INSTRUCTIONS_AREA_TOP = height/2 + 60;

  private final float HIGH_SCORE_AREA_LEFT = width/2 - 85;
  private final float HIGH_SCORE_AREA_TOP = height/2 + 60;

  private final float CREDITS_AREA_LEFT = width * .9 - 170;
  private final float CREDITS_AREA_TOP = height/2 + 60;

  StartGameScreen(ScreenChangeDelegate delegate) {
    super(delegate);
  }

  void drawScreen() {
    drawBackground();
    fill(255);
    textAlign(CENTER);
    textFont(getTitleFont());
    textSize(48);
    text("Bool Runnings", width/2, height/2);
    textFont(getMainFont());
    textSize(18);
    text("Made in Kachi presents...", width/2, height/2 - 55);

    textAlign(CENTER, TOP);
    textSize(30);
    text("Press Space to Start", width/2, groundLevel - 35);
    
    drawInstructionsButton();
    drawHighScoreButton();
    drawCreditsButton();
  }


  private void drawInstructionsButton() {
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideInstructions() ? #cccccc : 0x70ffffff);
    rect(INSTRUCTIONS_AREA_LEFT, INSTRUCTIONS_AREA_TOP, BUTTON_WIDTH, BUTTON_HEIGHT, 7);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textFont(getMainFont());
    textSize(28);
    text("Instructions", INSTRUCTIONS_AREA_LEFT, INSTRUCTIONS_AREA_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
  }

  private void drawHighScoreButton() {
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideHighScore() ? #cccccc : 0x70ffffff);
    rect(HIGH_SCORE_AREA_LEFT, HIGH_SCORE_AREA_TOP, BUTTON_WIDTH, BUTTON_HEIGHT, 7);

    fill(255);
    textAlign(CENTER, CENTER);
    textFont(getMainFont());
    textSize(28);
    text("High Scores", HIGH_SCORE_AREA_LEFT, HIGH_SCORE_AREA_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
  }

  private void drawCreditsButton() {
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideCredits() ? #cccccc : 0x70ffffff);
    rect(CREDITS_AREA_LEFT, CREDITS_AREA_TOP, BUTTON_WIDTH, BUTTON_HEIGHT, 7);

    fill(255);
    textAlign(CENTER, CENTER);
    textFont(getMainFont());
    textSize(28);
    text("Credits", CREDITS_AREA_LEFT, CREDITS_AREA_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
  }

  boolean handleKeyPressed() {
    if (key == ' ') {
      delegate.performScreenChange(null, null);
      return true;
    } 
    //shortcut to boss level
    /*else if (key == 'k') {
     Map<String, Object> transitionMap = new HashMap();
     transitionMap.put(ScreenChangeDelegate.KEY_SELECTED, PlayerType.AMERICAN);
     transitionMap.put(ScreenChangeDelegate.KEY_SCORE, 1650);
     transitionMap.put(ScreenChangeDelegate.KEY_TIME_REMAINING, 60000);
     transitionMap.put(ScreenChangeDelegate.KEY_HEALTH, 120);
     transitionMap.put(ScreenChangeDelegate.KEY_COINS, 600);
     delegate.performScreenChange(GameScreen.INVENTORY, transitionMap);
     return true;
     }*/

    return false;
  }

  boolean handleMouseClicked() {
    boolean handled = super.handleMouseClicked();
    if (!handled) {
      if (mouseInsideInstructions()) {
        delegate.performScreenChange(GameScreen.INSTRUCTIONS, new HashMap());
      } else if (mouseInsideHighScore()) {
        delegate.performScreenChange(GameScreen.HIGH_SCORE, new HashMap());
      } else if (mouseInsideCredits()) {
        delegate.performScreenChange(GameScreen.CREDITS, new HashMap());
      }
    }
    return handled;
  }

  private boolean mouseInsideInstructions() {
    return INSTRUCTIONS_AREA_LEFT <= mouseX && mouseX <= INSTRUCTIONS_AREA_LEFT + BUTTON_WIDTH
      && INSTRUCTIONS_AREA_TOP <= mouseY && mouseY <= INSTRUCTIONS_AREA_TOP + BUTTON_HEIGHT;
  }

  private boolean mouseInsideHighScore() {
    return HIGH_SCORE_AREA_LEFT <= mouseX && mouseX <= HIGH_SCORE_AREA_LEFT + BUTTON_WIDTH
      && HIGH_SCORE_AREA_TOP <= mouseY && mouseY <= HIGH_SCORE_AREA_TOP + BUTTON_HEIGHT;
  }

  private boolean mouseInsideCredits() {
    return CREDITS_AREA_LEFT <= mouseX && mouseX <= CREDITS_AREA_LEFT + BUTTON_WIDTH
      && CREDITS_AREA_TOP <= mouseY && mouseY <= CREDITS_AREA_TOP + BUTTON_HEIGHT;
  }
}