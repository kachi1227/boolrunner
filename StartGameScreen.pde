class StartGameScreen extends BaseGameScreen {

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
  }

  boolean handleKeyPressed() {
    if (key == ' ') {
      delegate.performScreenChange(null, null);
      return true;
    } else if (key == 'k') {
     Map<String, Object>transitionMap = new HashMap();
    transitionMap.put(ScreenChangeDelegate.KEY_SELECTED, PlayerType.AMERICAN);
    transitionMap.put(ScreenChangeDelegate.KEY_SCORE, 1650);
    transitionMap.put(ScreenChangeDelegate.KEY_TIME_REMAINING, 60000);
    transitionMap.put(ScreenChangeDelegate.KEY_HEALTH, 120);
    transitionMap.put(ScreenChangeDelegate.KEY_COINS, 600);
    delegate.performScreenChange(GameScreen.INVENTORY, transitionMap);
    return true;  
  }
    return false;
  }
}