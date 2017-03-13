class StartGameScreen extends BaseGameScreen {
  
  StartGameScreen(ScreenChangeDelegate delegate) {
    super(delegate);
  }

  void drawScreen() {
    drawBackground();
    fill(255);
    textAlign(CENTER);
    textSize(26);
    textFont(getTitleFont());
    text("Bool Runnings", width/2, height/2);
    textFont(getMainFont());
    textSize(18);
    text("Press Space to Start", width/2, height/2 + 25);
  }

  boolean handleKeyPressed() {
    if (key == ' ') {
      delegate.performScreenChange(null);
      return true;
    }
    return false;
  }
}