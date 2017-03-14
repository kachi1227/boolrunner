class MainScreen extends BaseGameScreen {

  final float WORLD_GRAVITY = 0.75;

  int cloudX;
  float treeOneX;
  float treeTwoX;

  int score;
  int health;
  int timeAllowed;
  int startMillis;
  int coinsCollected;

  int runnerX;

  BaseBobSled player;
  Obstacle[] obstacles = new Obstacle[20]; //fixed values..?
  //Coin[] coins = new Coin[3];
  Coin coin;
  Health collectableHealth;
  JumpBoost jumpBoost;
  TimeBoost timeBoost;
  FlameThrower flameThrower;
  
  Minim minim;
  AudioPlayer jamaicanAmbianceAudioPlayer;
  AudioPlayer americanAmbianceAudioPlayer;
  AudioPlayer currentAmbianceAudioPlayer;


  PFont hudFont;

  boolean disableForegroundDraw = false;

  MainScreen(ScreenChangeDelegate delegate) {
    super(delegate);
    float lastPosition = -1;
    for (int i=0; i < obstacles.length; i++) {
      lastPosition = lastPosition == -1 ? width : (lastPosition + random(700, 800));
      obstacles[i] = new Obstacle(lastPosition, groundLevel, speed, i > 16);
    }
    loadMusicFiles();
    hudFont = createFont("slkscre.ttf", 24);
    coin = new Coin(100, groundLevel, 0);
    collectableHealth = new Health(150, groundLevel, 0);
    jumpBoost = new JumpBoost(210, groundLevel, 0);
    timeBoost = new TimeBoost(260, groundLevel, 0);
    flameThrower = new FlameThrower(310, groundLevel, 0);
  }

  private void loadMusicFiles() {
    minim = new Minim(BoolRunnings.this);
    jamaicanAmbianceAudioPlayer = minim.loadFile("Temperature.mp3");
    jamaicanAmbianceAudioPlayer.setGain(-20);
    americanAmbianceAudioPlayer = minim.loadFile("PartyInTheUSA.mp3");
    americanAmbianceAudioPlayer.setGain(-20);
  }

  void reset(Map<String, Object> gameStateValues) {
    super.reset(gameStateValues);
    cloudX = width;
    treeOneX = width - 200;
    treeTwoX = 2 * width - 400;


    runnerX = 100;
    groundLevel = height - 100;
    if (gameStateValues != null) {
      //set player, set music
      PlayerType playerType = (PlayerType)gameStateValues.get(ScreenChangeDelegate.KEY_SELECTED);
      configureForSelectedPlayer(playerType);
    }
    for (int i=0; i < obstacles.length; i++) {
      obstacles[i].reset();
    }
    score = 0;
    health = 100;
    timeAllowed = 300;
    startMillis = millis();

    coinsCollected = 0;
  }

  private void configureForSelectedPlayer(PlayerType playerType) {
    if (currentAmbianceAudioPlayer != null) {
      currentAmbianceAudioPlayer.pause();
    }
    if (playerType == PlayerType.JAMAICAN) {
      player = new JamaicanBobSled(runnerX, groundLevel, WORLD_GRAVITY);
      currentAmbianceAudioPlayer = jamaicanAmbianceAudioPlayer;
    } else {
      player = new AmericanBobSled(runnerX, groundLevel, WORLD_GRAVITY);
      currentAmbianceAudioPlayer = americanAmbianceAudioPlayer;
    }
    currentAmbianceAudioPlayer.cue(0);
    //currentAmbianceAudioPlayer.loop();
  }

  void drawScreen() {
    drawBackground();
    drawCloud();    
    drawTrees();

    coin.updateForDraw();
    collectableHealth.updateForDraw();
    jumpBoost.updateForDraw();
    timeBoost.updateForDraw();
    flameThrower.updateForDraw();

    player.updateForDrawAtPosition();
    //TODO increase starting i value whenever obstacle passes or collides with player
    for (int i=0; i < obstacles.length; i++) {
      Obstacle obstacle = obstacles[i];
      //if (disableForegroundDraw) obstacle.updateForDisabled();
      //else obstacle.updateForDraw();
      obstacle.updateForDraw();
      if (obstacle.didCollide(player)) {
        health -= 25;
        //        disableForegroundDraw = true;
      } else if (obstacle.didPassPlayer(player)) {
        score += 100;
      }
    }
    drawHUD();
  }


  private void drawTrees() {
    fill(#00ff00);
    drawTree(treeOneX, #2F4F2F);
    treeOneX -= speed;
    if (treeOneX + 75 < 0) treeOneX = treeTwoX + width - 200;
    drawTree(treeTwoX, #006400);
    treeTwoX -= speed;
    if (treeTwoX + 75 < 0) treeTwoX = treeOneX + width - 200;
  }

  private void drawTree(float xPos, int treeColor) {
    float treeStumpTop = groundLevel - 50;
    fill(#8B5A2B);
    rect(xPos - 15, treeStumpTop, 30, 50);
    //fill()    
    fill(treeColor);
    triangle(xPos - 90, treeStumpTop + 5, xPos + 90, treeStumpTop + 5, xPos, treeStumpTop + 5 - 90);
    triangle(xPos - 80, treeStumpTop + 5 - 30, xPos + 80, treeStumpTop + 5 - 30, xPos, treeStumpTop + 5 - 30 - 70);
    triangle(xPos - 70, treeStumpTop + 5 - 30 - 30, xPos + 70, treeStumpTop + 5 - 30 - 30, xPos, treeStumpTop + 5 - 30 - 30 - 60);
  }

  private void drawCloud() {
    fill(255);
    ellipse(cloudX, 50, 100, 45);
    ellipse(cloudX + 50, 50, 100, 45);
    ellipse(cloudX + 25, 30, 100, 45);

    //update
    cloudX-=speed;
    if (cloudX + 95 < 0) {
      cloudX = width;
    }
  }

  private void drawHUD() {
    int currentTime = timeAllowed - (int)((millis() - startMillis)/1000);
    //println("Frame Counter: " + frameCounter + ". Frame Rate: " + frameRate + ". Counter/Rate: " + frameCounter/frameRate);
    textFont(hudFont);
    fill(#778899);
    textSize(32);

    textAlign(CENTER, TOP);
    int minutes = currentTime / 60;
    int seconds = currentTime % 60;
    text((Math.abs(minutes) < 10 ? ("0" + minutes) : minutes) + ":" + 
      (Math.abs(seconds) < 10 ? ("0" + seconds) : seconds), width/2, 10);

    textAlign(LEFT, TOP);
    text("Score: " + score, 10, 10);
    //health
    text(health, width - 85, 10);
    drawHeart();
  }

  private void drawHeart() {
    int heartStart = width - 120;
    int heartTop = 13;
    noStroke();
    fill(255, 1, 32);
    rect(heartStart + 2, heartTop + 2, 4, 12);
    rect(heartStart + 6, heartTop + 2, 4, 16); 
    rect(heartStart + 10, heartTop + 4, 6, 18); 
    rect(heartStart + 16, heartTop + 2, 4, 16); 
    rect(heartStart + 20, heartTop + 2, 4, 12); 

    fill(#778899);
    rect(heartStart, heartTop + 4, 2, 8);
    rect(heartStart + 2, heartTop + 2, 2, 2);
    rect(heartStart + 4, heartTop, 6, 2);
    rect(heartStart + 10, heartTop + 2, 2, 2);
    rect(heartStart + 12, heartTop + 4, 2, 2);
    rect(heartStart + 14, heartTop + 2, 2, 2);
    rect(heartStart + 16, heartTop, 6, 2);
    rect(heartStart + 22, heartTop + 2, 2, 2);
    rect(heartStart + 24, heartTop + 4, 2, 8);

    //diagonal bottom border
    rect(heartStart + 2, heartTop + 12, 2, 2);
    rect(heartStart + 22, heartTop + 12, 2, 2);

    rect(heartStart + 4, heartTop + 14, 2, 2);
    rect(heartStart + 20, heartTop + 14, 2, 2);

    rect(heartStart + 6, heartTop + 16, 2, 2);
    rect(heartStart + 18, heartTop + 16, 2, 2);

    rect(heartStart + 8, heartTop + 18, 2, 2);
    rect(heartStart + 16, heartTop + 18, 2, 2);
    rect(heartStart + 10, heartTop + 20, 2, 2);
    rect(heartStart + 14, heartTop + 20, 2, 2);

    rect(heartStart + 12, heartTop + 22, 2, 2);

    fill(255);
    rect(heartStart + 4, heartTop + 4, 2, 4);
    rect(heartStart + 6, heartTop + 4, 2, 2);
  }
  private void performCleanup() {
    currentAmbianceAudioPlayer.pause();
  }

  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (!handled) {
      //if space is pressed, perform jump.
      //if enter is used to start game, have that occur here (could also occur in mousePressed)
      if ( key == ' ' && !player.isJumping()) {
        player.performJump();
      }
      return true;
    }
    return false;
  }
}