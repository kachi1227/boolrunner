class ChoosePlayerScreen extends BaseGameScreen {

  private final float SELECT_AREA_WIDTH = 150;

  private final float JAMAICA_AREA_LEFT = width/2 - 75 - 150;
  private final float JAMAICA_AREA_TOP = height/2 - 50 - 75;

  private final float AMERICA_AREA_LEFT = width/2 + 75;
  private final float AMERICA_AREA_TOP = height/2 - 50 - 75;

  ChoosePlayerScreen(ScreenChangeDelegate delegate) {
    super(delegate);
  }

  void drawScreen() {
    drawBackground();
    drawSelectJamaicaArea();
    drawSelectAmericaArea();
    drawInformationalItems();
  }

  private void drawSelectJamaicaArea() {
    float flagLeft = JAMAICA_AREA_LEFT + 12.5;
    float flagTop = JAMAICA_AREA_TOP + 40;
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideJamaica() ? #cccccc : 0x90ffffff);
    rect(JAMAICA_AREA_LEFT, JAMAICA_AREA_TOP, SELECT_AREA_WIDTH, SELECT_AREA_WIDTH, 7);
    noStroke();
    fill(0, 145, 0);
    rect(flagLeft, flagTop, 125, 80);
    stroke(251, 239, 0);
    strokeWeight(15);
    line(flagLeft + 6.5, flagTop + 7, flagLeft + 118.25, flagTop + 72.5);
    line(flagLeft + 6.5, flagTop + 72.5, flagLeft + 118.25, flagTop + 7);
    fill(251, 239, 0);
    strokeWeight(1);
    triangle(flagLeft, flagTop, flagLeft, flagTop + 10, flagLeft + 8, flagTop);
    triangle(flagLeft, flagTop + 80, flagLeft, flagTop + 70, flagLeft + 8, flagTop + 80);

    triangle(flagLeft + 125, flagTop, flagLeft + 125, flagTop + 11, flagLeft + 125 - 8, flagTop);
    triangle(flagLeft + 125, flagTop + 80, flagLeft + 125, flagTop + 80 - 10, flagLeft + 125 - 10, flagTop + 80);
    stroke(0);
    fill(0);
    triangle(flagLeft, flagTop + 11, flagLeft, flagTop + 67, flagLeft + 47, flagTop + 40);
    triangle(flagLeft + 125, flagTop + 11, flagLeft + 125, flagTop + 67, flagLeft + 125 - 47, flagTop + 40);


    fill(255);
    textAlign(CENTER);
    textFont(getMainFont());
    textSize(28);
    text("Jamaica", JAMAICA_AREA_LEFT, JAMAICA_AREA_TOP + SELECT_AREA_WIDTH + 15, SELECT_AREA_WIDTH, 40);
  }

  private void drawSelectAmericaArea() {
    float flagLeft = AMERICA_AREA_LEFT + 12.5;
    float flagTop = AMERICA_AREA_TOP + 40;
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideAmerica() ? #cccccc : 0x90ffffff);
    rect(AMERICA_AREA_LEFT, AMERICA_AREA_TOP, SELECT_AREA_WIDTH, SELECT_AREA_WIDTH, 7);
    noStroke();
    fill(178, 34, 52);
    rect(flagLeft, flagTop, 125, 80);
    fill(255);
    for (int i=0; i < 6; i++) {
      rect(flagLeft, flagTop + 6.15 + (12.3 * i), 125, 6.15);
    }
    fill(60, 59, 110);
    rect(flagLeft, flagTop, 40, 35);
    fill(255);
    for (int i=0; i < 5; i++) {
      int starMax = i % 2 == 0 ? 6 : 5;
      int startOffset = starMax == 6 ? 3 : 6;
      for (int j=0; j < starMax; j++) {
        ellipse(flagLeft + startOffset + 1.5 + (j * 6), flagTop + 5 + (i * 6), 3, 3);
      }
    }

    fill(255);
    textAlign(CENTER);
    textFont(getMainFont());
    textSize(28);
    text("USA", AMERICA_AREA_LEFT, AMERICA_AREA_TOP + SELECT_AREA_WIDTH + 15, SELECT_AREA_WIDTH, 40);
  }

  private void drawInformationalItems() {
    textFont(getTitleFont());
    fill(255);
    textSize(40);

    textAlign(CENTER, TOP);
    text("Choose A Team", width/2, 10);

    textFont(getMainFont());
    textSize(30);
    text("Click to Select", width/2, groundLevel - 35);

    drawDescriptionText();
  }

  private void drawDescriptionText() {
    String descriptiveText = "";
    if (mouseInsideJamaica()) {
      descriptiveText = "Wa gwan, bredrin. Mi se rudeboy fi win di whole ting. Dun kno.";
    } else if (mouseInsideAmerica()) {
      descriptiveText = "Team USA. Sorry again for that Trump guy. The Russians will pay.";
    }

    fill(#778899);
    textFont(getMainFont());
    textSize(24);
    textAlign(CENTER, CENTER);
    text(descriptiveText, 10, groundLevel, width - 20, 100);
  }


  boolean handleMouseClicked() {
    boolean handled = super.handleKeyPressed();
    if (!handled) {
      if (mouseInsideJamaica()) {
        //pass jamaican value
        Map<String, Object> selectionMap = new HashMap();
        selectionMap.put(ScreenChangeDelegate.KEY_SELECTED, PlayerType.JAMAICAN);
        delegate.performScreenChange(null, selectionMap);
        return true;
      } else if (mouseInsideAmerica()) {
        //pass american value
        Map<String, Object> selectionMap = new HashMap();
        selectionMap.put(ScreenChangeDelegate.KEY_SELECTED, PlayerType.AMERICAN);
        delegate.performScreenChange(null, selectionMap);
        return true;
      }
    }
    return handled;
  }
  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (!handled) {
      return true;
    }
    return false;
  }


  private boolean mouseInsideJamaica() {
    return JAMAICA_AREA_LEFT <= mouseX && mouseX <= JAMAICA_AREA_LEFT + SELECT_AREA_WIDTH
      && JAMAICA_AREA_TOP <= mouseY && mouseY <= JAMAICA_AREA_TOP + SELECT_AREA_WIDTH;
  }

  private boolean mouseInsideAmerica() {
    return AMERICA_AREA_LEFT <= mouseX && mouseX <= AMERICA_AREA_LEFT + SELECT_AREA_WIDTH
      && AMERICA_AREA_TOP <= mouseY && mouseY <= AMERICA_AREA_TOP + SELECT_AREA_WIDTH;
  }
}