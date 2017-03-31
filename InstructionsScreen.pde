class InstructionsScreen extends BaseGameScreen {

  InstructionsScreen(ScreenChangeDelegate delegate) {
    super(delegate);
  }

  void drawScreen() {
    drawBackground();
    drawInformationalItems();
  }

  private void drawInformationalItems() {
    textFont(getTitleFont());
    fill(255);
    textSize(40);

    textAlign(CENTER, TOP);
    text("Instructions", width/2, 10);
    textSize(30);
    text("Keys", width/2, 180);
    textFont(getMainFont());
    textSize(30);
    text("Press Space to Go Back", width/2, groundLevel - 35);
    textAlign(LEFT, TOP);
    textSize(24);
    text("Objective: Collect as many coins and powerups as possible while avoiding the obstacles in the " + 
      "qualifying race. Once you've qualifed, use snowballs and other projectiles to defeat your arch rival once and for all!", 
      20, 70, width - 40, 300);

    text("1 - Equip Snowball or Jump Boost\n\n3 - Equip Icicle Thrower\n\n5 - Equip Bullet Time", 
      70, 230, width/2 - 40, 300);
      
      
    text("2 - Equip Flamethrower\n\n4 - Equip Shield\n\nEnter - Use Equipped Item", 
      width/2 + 70, 230, width/2 - 40, 300);
  }

  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (!handled) {
      if (key == ' ') {
        delegate.performScreenChange(null, null);
        return true;
      }
    }
    return false;
  }
}