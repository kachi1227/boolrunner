class InventoryItemOrder {
  BaseCollectable collectable;
  int bundleSize;
  InventoryItemOrder(BaseCollectable collectable, int bundle) {
    this.collectable = collectable;
    this.bundleSize = bundle;
  }
}

class InventorySelectionScreen extends BaseGameScreen {

  private final static int HEALTH_COST = 55;
  private final static int SHIELD_COST = 60;
  private final static int FIREBALL_COST = 75;
  private final static int ICICLE_COST = 80;
  private final static int BULLET_TIME_COST = 85;

  private final float SELECT_AREA_WIDTH = 125;

  private final float HEALTH_AREA_LEFT = width/2 - 25 - 125;
  private final float HEALTH_AREA_TOP = height/2 - 160 - 62.5;

  private final float SHIELD_AREA_LEFT = width/2 + 5;
  private final float SHIELD_AREA_TOP = height/2 - 160 - 62.5;

  private final float FLAMETHROWER_AREA_LEFT = width/3 - 75;
  private final float FLAMETHROWER_AREA_TOP = height/2 + 40 - 75;

  private final float ICETHROWER_AREA_LEFT = width/3 + 75;
  private final float ICETHROWER_AREA_TOP = height/2 + 40 - 75;

  private final float BULLET_TIME_AREA_LEFT = width/3 + 75 + 150;
  private final float BULLET_TIME_AREA_TOP = height/2 + 40 - 75;


  int coinsTotal = 0;
  int playerHealth = 0;

  HeartEightBitImageGenerator heartGenerator;
  SnowballEightBitImageGenerator snowGenerator;
  FlameEightBitImageGenerator flameGenerator;
  IceEightBitImageGenerator iceGenerator;
  ShieldEightBitImageGenerator shieldGenerator;
  HourGlassEightBitImageGenerator clockGenerator;
  CoinEightBitImageGenerator coinGenerator;

  String insufficientFundsMessage;

  Map<String, Object> currentPlayerState;
  List<InventoryItemOrder> orderedItems;

  InventorySelectionScreen(ScreenChangeDelegate delegate) {
    super(delegate);
    initEightBitItems();
    orderedItems = new ArrayList();
  }

  private void initEightBitItems() {
    heartGenerator = new HeartEightBitImageGenerator(4);
    shieldGenerator = new ShieldEightBitImageGenerator(3);
    snowGenerator = new SnowballEightBitImageGenerator(3);
    flameGenerator = new FlameEightBitImageGenerator(3);
    iceGenerator = new IceEightBitImageGenerator(3);
    clockGenerator = new HourGlassEightBitImageGenerator(3);
    coinGenerator = new CoinEightBitImageGenerator(2);
  }

  void reset(Map<String, Object> gameStateValues) {
    super.reset(gameStateValues);
    orderedItems.clear();
    if (gameStateValues == null) return;
    currentPlayerState = gameStateValues;
    coinsTotal = (int)gameStateValues.get(ScreenChangeDelegate.KEY_COINS);
    playerHealth = (int)gameStateValues.get(ScreenChangeDelegate.KEY_HEALTH);
  }

  public void drawScreen() {
    drawBackground();
    drawSelectMoreHealthArea();
    drawSelectShieldArea();
    drawSelectFlamethrowerArea();
    drawSelectIcicleThrowerArea();
    drawSelectBulletTime();
    drawInformationalItems();
  }


  private void drawInformationalItems() {
    textFont(getTitleFont());
    fill(255);
    textSize(40);

    textAlign(CENTER, TOP);
    text("Rival Preparation", width/2, 10);

    textFont(getMainFont());
    textSize(30);
    text("Press Space When Ready", width/2, groundLevel - 35);

    textAlign(LEFT, TOP);
    textFont(getEightBitFont());
    fill(#778899);
    textSize(28);
    //coins
    coinGenerator.setScaleFactor(2);
    text("x" + coinsTotal, width - 110, 11);
    coinGenerator.drawImage(width - 150, 8);

    fill(#778899);
    textSize(32);

    textAlign(LEFT, TOP);
    //health
    text(playerHealth, 45, 10);
    heartGenerator.setScaleFactor(2);
    heartGenerator.drawImage(10, 13);

    drawDescriptionText();
  }

  private void drawDescriptionText() {
    String descriptiveText = "";
    if (insufficientFundsMessage != null) {
      descriptiveText = insufficientFundsMessage;
    } else if (mouseInsideHealth()) {
      descriptiveText = "Increases health points by 15. Thanks, Obamacare.";
    } else if (mouseInsideShield()) {
      descriptiveText = "Take up to " + Shield.HITS_PER_SHIELD + " hits from rival without losing health points.";
    } else if (mouseInsideFireball()) {
      descriptiveText = "24 fireballs for flamethrower. Rival loses 2 health points for every fireball hit. Also melts rival snowballs.";
    } else if (mouseInsideIcicle()) {
      descriptiveText = "16 icicles for iciclethrower. Rival loses 4 health points for every icicle hit. Beware: Can turn rival snowballs into icicles.";
    } else if (mouseInsideBulletTime()) {
      descriptiveText = "This is exactly what you think it is. Matrix time for 10 seconds, pleighboi.";
    }

    fill(#778899);
    textFont(getMainFont());
    textSize(24);
    textAlign(CENTER, CENTER);
    text(descriptiveText, 10, groundLevel, width - 20, 100);
  }

  private void drawSelectMoreHealthArea() {
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideHealth() ? #cccccc : 0x90ffffff);
    rect(HEALTH_AREA_LEFT, HEALTH_AREA_TOP, SELECT_AREA_WIDTH, SELECT_AREA_WIDTH, 7);

    textSize(24);
    coinGenerator.setScaleFactor(1.5);
    float startingX = HEALTH_AREA_LEFT + SELECT_AREA_WIDTH/2 - 30;
    float startingY = HEALTH_AREA_TOP + SELECT_AREA_WIDTH - coinGenerator.getAdjustedImageHeight() - 7;
    coinGenerator.drawImage(startingX, startingY);
    textAlign(LEFT, TOP);
    text(String.valueOf(HEALTH_COST), startingX + coinGenerator.getAdjustedImageWidth() + 7, startingY + 3);
    heartGenerator.setScaleFactor(4);
    heartGenerator.drawImage(HEALTH_AREA_LEFT + (SELECT_AREA_WIDTH - heartGenerator.getAdjustedImageWidth())/2, 
      HEALTH_AREA_TOP + (SELECT_AREA_WIDTH - heartGenerator.getAdjustedImageHeight() - coinGenerator.getAdjustedImageHeight())/2);

    fill(#778899);
    textAlign(CENTER);
    textFont(getMainFont());
    textSize(28);
    text("Health", HEALTH_AREA_LEFT, HEALTH_AREA_TOP + SELECT_AREA_WIDTH + 15, SELECT_AREA_WIDTH, 40);
  }

  private void drawSelectShieldArea() {
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideShield() ? #cccccc : 0x90ffffff);
    rect(SHIELD_AREA_LEFT, SHIELD_AREA_TOP, SELECT_AREA_WIDTH, SELECT_AREA_WIDTH, 7);

    textSize(24);
    coinGenerator.setScaleFactor(1.5);
    float startingX = SHIELD_AREA_LEFT + SELECT_AREA_WIDTH/2 - 30;
    float startingY = SHIELD_AREA_TOP + SELECT_AREA_WIDTH - coinGenerator.getAdjustedImageHeight() - 7;
    coinGenerator.drawImage(startingX, startingY);
    textAlign(LEFT, TOP);
    text(String.valueOf(SHIELD_COST), startingX + coinGenerator.getAdjustedImageWidth() + 7, startingY + 3);

    shieldGenerator.drawImage(SHIELD_AREA_LEFT + (SELECT_AREA_WIDTH - shieldGenerator.getAdjustedImageWidth())/2, 
      SHIELD_AREA_TOP + (SELECT_AREA_WIDTH - shieldGenerator.getAdjustedImageHeight() - coinGenerator.getAdjustedImageHeight())/2);
    fill(#778899);
    textAlign(CENTER);
    textFont(getMainFont());
    textSize(28);
    text("Shield", SHIELD_AREA_LEFT, SHIELD_AREA_TOP + SELECT_AREA_WIDTH + 15, SELECT_AREA_WIDTH, 40);
  }


  private void drawSelectFlamethrowerArea() {
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideFireball() ? #cccccc : 0x90ffffff);
    rect(FLAMETHROWER_AREA_LEFT, FLAMETHROWER_AREA_TOP, SELECT_AREA_WIDTH, SELECT_AREA_WIDTH, 7);

    textSize(24);
    coinGenerator.setScaleFactor(1.5);
    float startingX = FLAMETHROWER_AREA_LEFT + SELECT_AREA_WIDTH/2 - 30;
    float startingY = FLAMETHROWER_AREA_TOP + SELECT_AREA_WIDTH - coinGenerator.getAdjustedImageHeight() - 7;
    coinGenerator.drawImage(startingX, startingY);
    textAlign(LEFT, TOP);
    text(String.valueOf(FIREBALL_COST), startingX + coinGenerator.getAdjustedImageWidth() + 7, startingY + 3);


    flameGenerator.drawImage(FLAMETHROWER_AREA_LEFT + (SELECT_AREA_WIDTH - flameGenerator.getAdjustedImageWidth())/2, 
      FLAMETHROWER_AREA_TOP + (SELECT_AREA_WIDTH - flameGenerator.getAdjustedImageHeight() - coinGenerator.getAdjustedImageHeight())/2);

    fill(#778899);
    textAlign(CENTER);
    textFont(getMainFont());
    textSize(28);
    text("Fireball Ammo", FLAMETHROWER_AREA_LEFT, FLAMETHROWER_AREA_TOP + SELECT_AREA_WIDTH + 15, SELECT_AREA_WIDTH, 40);
  }

  private void drawSelectIcicleThrowerArea() {
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideIcicle() ? #cccccc : 0x90ffffff);
    rect(ICETHROWER_AREA_LEFT, ICETHROWER_AREA_TOP, SELECT_AREA_WIDTH, SELECT_AREA_WIDTH, 7);

    textSize(24);
    coinGenerator.setScaleFactor(1.5);
    float startingX = ICETHROWER_AREA_LEFT + SELECT_AREA_WIDTH/2 - 40;
    float startingY = ICETHROWER_AREA_TOP + SELECT_AREA_WIDTH - coinGenerator.getAdjustedImageHeight() - 7;
    coinGenerator.drawImage(startingX, startingY);
    textAlign(LEFT, TOP);
    text(String.valueOf(ICICLE_COST), startingX + coinGenerator.getAdjustedImageWidth() + 7, startingY + 3);


    iceGenerator.drawImage(ICETHROWER_AREA_LEFT + (SELECT_AREA_WIDTH - iceGenerator.getAdjustedImageWidth())/2, 
      ICETHROWER_AREA_TOP + (SELECT_AREA_WIDTH - iceGenerator.getAdjustedImageHeight() - coinGenerator.getAdjustedImageHeight())/2);

    fill(#778899);
    textAlign(CENTER);
    textFont(getMainFont());
    textSize(28);
    text("Icicle Ammo", ICETHROWER_AREA_LEFT, ICETHROWER_AREA_TOP + SELECT_AREA_WIDTH + 15, SELECT_AREA_WIDTH, 40);
  }

  private void drawSelectBulletTime() {
    stroke(255);
    strokeWeight(5);
    fill(mousePressed && mouseInsideBulletTime() ? #cccccc : 0x90ffffff);
    rect(BULLET_TIME_AREA_LEFT, BULLET_TIME_AREA_TOP, SELECT_AREA_WIDTH, SELECT_AREA_WIDTH, 7);

    textSize(24);
    coinGenerator.setScaleFactor(1.5);
    float startingX = BULLET_TIME_AREA_LEFT + SELECT_AREA_WIDTH/2 - 40;
    float startingY = BULLET_TIME_AREA_TOP + SELECT_AREA_WIDTH - coinGenerator.getAdjustedImageHeight() - 7;
    coinGenerator.drawImage(startingX, startingY);
    textAlign(LEFT, TOP);
    text(String.valueOf(BULLET_TIME_COST), startingX + coinGenerator.getAdjustedImageWidth() + 7, startingY + 3);

    clockGenerator.drawImage(BULLET_TIME_AREA_LEFT + (SELECT_AREA_WIDTH - clockGenerator.getAdjustedImageWidth())/2, 
      BULLET_TIME_AREA_TOP + (SELECT_AREA_WIDTH - clockGenerator.getAdjustedImageHeight() - coinGenerator.getAdjustedImageHeight())/2);

    fill(#778899);
    textAlign(CENTER);
    textFont(getMainFont());
    textSize(28);
    text("Bullet Time", BULLET_TIME_AREA_LEFT - 20, BULLET_TIME_AREA_TOP + SELECT_AREA_WIDTH + 15, SELECT_AREA_WIDTH + 40, 40);
  }

  private boolean attemptPurchase(int cost, InventoryItemOrder order) {
    if (coinsTotal >= cost) {
      coinsTotal-= cost;
      orderedItems.add(order);
      return true;
    } else {
      insufficientFundsMessage = "Not Enough Coins to Get This Item. Sorry :(";
      return false;
    }
  }

  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (!handled) {
      if (key == ' ') {
        currentPlayerState.put(ScreenChangeDelegate.KEY_INVENTORY, orderedItems);
        currentPlayerState.put(ScreenChangeDelegate.KEY_COINS, coinsTotal);
        delegate.performScreenChange(null, currentPlayerState);
      }
      return true;
    }
    return false;
  }

  boolean handleMouseClicked() {
    boolean handled = super.handleMouseClicked();
    if (!handled) {
      if (mouseInsideHealth()) {
        if (attemptPurchase(HEALTH_COST, new InventoryItemOrder(new Health(0, 0, 0, 0), 1))) {
          playerHealth += 15;
        }
        return true;
      } else if (mouseInsideShield()) {
        attemptPurchase(SHIELD_COST, new InventoryItemOrder(new Shield(0, 0, 0, 0), 1));
        return true;
      } else if (mouseInsideFireball()) {
        attemptPurchase(FIREBALL_COST, new InventoryItemOrder(new FlameThrowerAmmo(0, 0, 0, 0), 24));
      } else if (mouseInsideIcicle()) {
        attemptPurchase(ICICLE_COST, new InventoryItemOrder(new Icicle(0, 0, 0, 0), 16));
      } else if (mouseInsideBulletTime()) {
        attemptPurchase(BULLET_TIME_COST, new InventoryItemOrder(new BulletTime(0, 0, 0, 0), 1));
      }
    }
    return handled;
  }


  boolean handleMouseMoved() {
    boolean handled = super.handleMouseMoved();
    if (!handled) {
      if (insufficientFundsMessage != null) insufficientFundsMessage = null;
    }
    return handled;
  }


  private boolean mouseInsideHealth() {
    return HEALTH_AREA_LEFT <= mouseX && mouseX <= HEALTH_AREA_LEFT + SELECT_AREA_WIDTH
      && HEALTH_AREA_TOP <= mouseY && mouseY <= HEALTH_AREA_TOP + SELECT_AREA_WIDTH;
  }

  private boolean mouseInsideShield() {
    return SHIELD_AREA_LEFT <= mouseX && mouseX <= SHIELD_AREA_LEFT + SELECT_AREA_WIDTH
      && SHIELD_AREA_TOP <= mouseY && mouseY <= SHIELD_AREA_TOP + SELECT_AREA_WIDTH;
  }

  private boolean mouseInsideFireball() {
    return FLAMETHROWER_AREA_LEFT <= mouseX && mouseX <= FLAMETHROWER_AREA_LEFT + SELECT_AREA_WIDTH
      && FLAMETHROWER_AREA_TOP <= mouseY && mouseY <= FLAMETHROWER_AREA_TOP + SELECT_AREA_WIDTH;
  }

  private boolean mouseInsideIcicle() {
    return ICETHROWER_AREA_LEFT <= mouseX && mouseX <= ICETHROWER_AREA_LEFT + SELECT_AREA_WIDTH
      && ICETHROWER_AREA_TOP <= mouseY && mouseY <= ICETHROWER_AREA_TOP + SELECT_AREA_WIDTH;
  }

  private boolean mouseInsideBulletTime() {
    return BULLET_TIME_AREA_LEFT <= mouseX && mouseX <= BULLET_TIME_AREA_LEFT + SELECT_AREA_WIDTH
      && BULLET_TIME_AREA_TOP <= mouseY && mouseY <= BULLET_TIME_AREA_TOP + SELECT_AREA_WIDTH;
  }
}