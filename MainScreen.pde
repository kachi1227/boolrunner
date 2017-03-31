import java.util.Collection;
class MainScreen extends BaseGameScreen {

  final float WORLD_GRAVITY = 0.75;

  int cloudX;
  float treeOneX;
  float treeTwoX;

  int timeAllowed;
  int startMillis;
  int coinsCollected;

  int runnerX;
  float totalDistanceTravelled;

  BaseBobSled player;
  float distanceRequiredToTravel;
  int obstacleStartIndex = 0;
  Obstacle[] obstacles; //fixed values..?
  int obstaclesSeen;
  int coinStartIndex = 0;
  Coin[] coins;
  int heartStartIndex = 0;
  Health[] hearts;
  int jumpBoostStartIndex = 0;
  JumpBoost[] jumpBoosts;
  int flameAmmoStartIndex = 0;
  FlameThrowerAmmo[] fireballs;

  CoinEightBitImageGenerator coinGenerator;
  FlameEightBitImageGenerator flameGenerator;
  HeartEightBitImageGenerator heartGenerator;
  JumpArrowEightBitImageGenerator jumpGenerator;

  List<BaseProjectile> activeProjectiles;

  AudioPlayer jamaicanAmbianceAudioPlayer;
  AudioPlayer americanAmbianceAudioPlayer;
  AudioPlayer currentAmbianceAudioPlayer;

  boolean levelPassed = false;
  boolean disableForegroundDraw = false;

  MainScreen(ScreenChangeDelegate delegate) {
    super(delegate);
    activeProjectiles = new ArrayList();
    readWorldFile();
    loadMusicFiles();
    initHUDElements();
  }
  private void readWorldFile() {
    JSONObject worldData = loadJSONObject("world_data.json");
    JSONArray worldConfigs = worldData.getJSONArray("world_configs");
    int worldIndex = worldData.getInt("world_index");
    if (worldIndex == -1) {
      worldIndex = int(random(0, worldConfigs.size()));
    }
    JSONObject json = worldConfigs.getJSONObject(worldIndex);
    JSONArray obstacleDataArray = json.getJSONArray("obstacles");
    obstacles = new Obstacle[obstacleDataArray.size()];
    for (int i=0; i < obstacleDataArray.size(); i++) {
      JSONObject obstacleData = obstacleDataArray.getJSONObject(i);
      obstacles[i] = new Obstacle(obstacleData.getFloat("x"), groundLevel, speed, obstacleData.getBoolean("dynamic"));
    }

    JSONArray coinDataArray = json.getJSONArray("coins");
    coins = new Coin[coinDataArray.size()];
    for (int i=0; i < coinDataArray.size(); i++) {
      JSONObject coinData = coinDataArray.getJSONObject(i);
      coins[i] = new Coin(coinData.getFloat("x"), groundLevel, coinData.getFloat("y"), speed);
    }
    JSONArray healthDataArray = json.getJSONArray("health");
    hearts = new Health[healthDataArray.size()];
    for (int i=0; i < healthDataArray.size(); i++) {
      JSONObject healthData = healthDataArray.getJSONObject(i);
      hearts[i] = new Health(healthData.getFloat("x"), groundLevel, healthData.getFloat("y"), speed);
    }
    JSONArray jumpBoostDataArray = json.getJSONArray("jump_boosts");
    jumpBoosts = new JumpBoost[jumpBoostDataArray.size()];
    for (int i=0; i < jumpBoostDataArray.size(); i++) {
      JSONObject jumpData = jumpBoostDataArray.getJSONObject(i);
      jumpBoosts[i] = new JumpBoost(jumpData.getFloat("x"), groundLevel, jumpData.getFloat("y"), speed);
    }
    JSONArray fireballDataArray = json.getJSONArray("fireballs");
    fireballs = new FlameThrowerAmmo[fireballDataArray.size()];
    for (int i=0; i < fireballDataArray.size(); i++) {
      JSONObject fireballData = fireballDataArray.getJSONObject(i);
      fireballs[i] = new FlameThrowerAmmo(fireballData.getFloat("x"), groundLevel, fireballData.getFloat("y"), speed);
    }


    distanceRequiredToTravel = json.getFloat("distance_to_travel");
  }

  private void loadMusicFiles() {
    Minim minim = new Minim(BoolRunnings.this);
    jamaicanAmbianceAudioPlayer = minim.loadFile("Temperature.mp3");
    jamaicanAmbianceAudioPlayer.setGain(-20);
    americanAmbianceAudioPlayer = minim.loadFile("PartyInTheUSA.mp3");
    americanAmbianceAudioPlayer.setGain(-20);
  }

  private void initHUDElements() {
    coinGenerator = new CoinEightBitImageGenerator(2);
    flameGenerator = new FlameEightBitImageGenerator(1.5);
    heartGenerator = new HeartEightBitImageGenerator(2);
    jumpGenerator = new JumpArrowEightBitImageGenerator(1);
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

    for (int i=0; i < coins.length; i++) {
      coins[i].reset();
    }

    for (int i=0; i < hearts.length; i++) {
      hearts[i].reset();
    }

    for (int i=0; i < jumpBoosts.length; i++) {
      jumpBoosts[i].reset();
    }

    for (int i=0; i < fireballs.length; i++) {
      fireballs[i].reset();
    }

    obstacleStartIndex = 0;
    coinStartIndex = 0;
    heartStartIndex = 0;
    jumpBoostStartIndex = 0;
    flameAmmoStartIndex = 0;

    obstaclesSeen = 0;
    timeAllowed = 120;
    startMillis = millis();

    coinsCollected = 0;
    totalDistanceTravelled = 0;
    levelPassed = false;
  }

  private void configureForSelectedPlayer(PlayerType playerType) {
    if (currentAmbianceAudioPlayer != null) {
      currentAmbianceAudioPlayer.pause();
    }
    WorldInteractionDelegate worldInteractDelegate = new WorldInteractionDelegate() {
      public void addProjectileToWorld(BaseProjectile projectile) {
        addProjectileToActiveList(projectile);
      }

      public void bulletTimeStatusChange(boolean enabled) {
      }
    };
    if (playerType == PlayerType.JAMAICAN) {
      player = new JamaicanBobSled(runnerX, groundLevel, WORLD_GRAVITY, worldInteractDelegate);
      currentAmbianceAudioPlayer = jamaicanAmbianceAudioPlayer;
    } else {
      player = new AmericanBobSled(runnerX, groundLevel, WORLD_GRAVITY, worldInteractDelegate);
      currentAmbianceAudioPlayer = americanAmbianceAudioPlayer;
    }
    currentAmbianceAudioPlayer.cue(0);
    currentAmbianceAudioPlayer.loop();
  }

  private void addProjectileToActiveList(BaseProjectile projectile) {
    activeProjectiles.add(projectile);
  }

  void drawScreen() {
    if (levelPassed) return;
    //println(frameRate);
    drawBackground();
    drawCloud();    
    drawTrees();

    for (int i=coinStartIndex; i < coins.length; i++) {
      Coin coin = coins[i];
      if (coin.isOnScreen()) {
        coin.updateForDraw();
        coin.didCollide(player);
      } else if (coin.onScreenAfterDistance(-totalDistanceTravelled)) {
        coin.setOffset(totalDistanceTravelled);
        coin.updateForDraw();
        coin.didCollide(player);
      } else if (coin.getRelationToScreen() == Moveable.LEFT_OF_SCREEN) {
        coinStartIndex = i + 1;
      } else break;
    }
    for (int i=heartStartIndex; i < hearts.length; i++) {
      Health health = hearts[i];
      if (health.isOnScreen()) {
        health.updateForDraw();
        health.didCollide(player);
      } else if (health.onScreenAfterDistance(-totalDistanceTravelled)) {
        health.setOffset(totalDistanceTravelled);
        health.updateForDraw();
        health.didCollide(player);
      } else if (health.getRelationToScreen() == Moveable.LEFT_OF_SCREEN) {
        heartStartIndex = i + 1;
      } else break;
    }
    for (int i=jumpBoostStartIndex; i < jumpBoosts.length; i++) {
      JumpBoost boost = jumpBoosts[i];
      if (boost.isOnScreen()) {
        boost.updateForDraw();
        boost.didCollide(player);
      } else if (boost.onScreenAfterDistance(-totalDistanceTravelled)) {
        boost.setOffset(totalDistanceTravelled);
        boost.updateForDraw();
        boost.didCollide(player);
      } else if (boost.getRelationToScreen() == Moveable.LEFT_OF_SCREEN) {
        jumpBoostStartIndex = i + 1;
      } else break;
    }
    for (int i=flameAmmoStartIndex; i < fireballs.length; i++) {
      FlameThrowerAmmo ammo = fireballs[i];
      if (ammo.isOnScreen()) {
        ammo.updateForDraw();
        ammo.didCollide(player);
      } else if (ammo.onScreenAfterDistance(-totalDistanceTravelled)) {
        ammo.setOffset(totalDistanceTravelled);
        ammo.updateForDraw();
        ammo.didCollide(player);
      } else if (ammo.getRelationToScreen() == Moveable.LEFT_OF_SCREEN) {
        flameAmmoStartIndex = i + 1;
      } else break;
    }


    player.updateForDrawAtPosition();

    //TODO increase starting i value whenever obstacle passes or collides with player
    List<Obstacle> visibleObstacles = new ArrayList();
    for (int i=obstacleStartIndex; i < obstacles.length; i++) {
      Obstacle obstacle = obstacles[i];
      if (obstacle.isOnScreen()) {
        //if (disableForegroundDraw) obstacle.updateForDisabled();
        //else obstacle.updateForDraw();
        obstacle.updateForDraw(false);
        checkForPlayerInteraction(obstacle);
        if (!obstacle.isDestroyed()) visibleObstacles.add(obstacle);
      } else if (obstacle.onScreenAfterDistance(-totalDistanceTravelled)) {
        obstacle.setOffset(totalDistanceTravelled);
        obstacle.updateForDraw(false);
        checkForPlayerInteraction(obstacle);
        if (!obstacle.isDestroyed()) visibleObstacles.add(obstacle);
      } else if (obstacle.getRelationToScreen() == Moveable.LEFT_OF_SCREEN) {
        obstacleStartIndex = i + 1;
      } else break;
    }

    //we should get box representing first obstacle on screen and see if projectile hits it...
    //keep track of the index with the projectile that's furtherest ahead.
    Map<String, BaseProjectile> heightToProjectileMap = new HashMap();
    for (int i=activeProjectiles.size() - 1; i >= 0; i--) {
      BaseProjectile projectile = activeProjectiles.get(i);
      if (projectile.isOnScreen()) {
        projectile.updateForDraw();
        String projKey = projectile.getTopSideY() + "" + projectile.getHeight();
        if (heightToProjectileMap.containsKey(projKey)) {
          BaseProjectile mainProjectileAtHeight = heightToProjectileMap.get(projKey);
          if (projectile.getRightSideX() > mainProjectileAtHeight.getRightSideX()) {
            heightToProjectileMap.put(projKey, projectile);
          }
        } else {
          heightToProjectileMap.put(projKey, projectile);
        }
      } else {
        activeProjectiles.remove(projectile);
      }
    }
    for (BaseProjectile projectile : heightToProjectileMap.values()) {
      for (Obstacle obstacle : visibleObstacles) {
        if (projectile.getBottomSideY() > obstacle.getTopSideY()) {
          if (!obstacle.isDestroyed() && !obstacle.isCollided() && 
            projectile.didPenetrateHitRect(obstacle.getLeftSideX(), obstacle.getTopSideY(), obstacle.getWidth(), obstacle.getHeight())) {
            obstacle.destroy();
            obstaclesSeen++;
            activeProjectiles.remove(projectile);
            player.incrementScoreForProjectileHit(projectile);
          }
        }
      }
    }

    drawHUD();
    totalDistanceTravelled += speed;

    if (totalDistanceTravelled > distanceRequiredToTravel) {
      advanceToNextLevel();
    }
  }

  private void checkForPlayerInteraction(Obstacle obstacle) {
    if (obstacle.didCollide(player)) {
      player.takeDamage();
      obstaclesSeen++;
      if (player.getHealth() <= 0) endGame();
    } else if (obstacle.didPassPlayer(player)) {
      player.incrementScoreForObstaclePass();
      obstaclesSeen++;
    }
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
    textFont(getEightBitFont());
    fill(#778899);
    textSize(32);

    textAlign(CENTER, TOP);
    text("Score: " + player.getScore(), width/2, 10);
    text(obstaclesSeen + "/" + obstacles.length, width/2, 40);


    textAlign(LEFT, TOP);
    //health
    text(player.getHealth(), 45, 10);
    heartGenerator.drawImage(10, 13);
    fill(#778899);
    //time
    int minutes = currentTime / 60;
    int seconds = currentTime % 60;
    text((Math.abs(minutes) < 10 ? ("0" + minutes) : minutes) + ":" + 
      (Math.abs(seconds) < 10 ? ("0" + seconds) : seconds), 10, 13 + heartGenerator.getAdjustedImageHeight() + 8);

    textAlign(LEFT, TOP);
    fill(#778899);
    textSize(28);
    //coins
    text("x" + player.getCoinCount(), width - 110, 11);
    coinGenerator.drawImage(width - 150, 8);

    fill(#778899);
    textSize(24);

    if (player.getEquippedItemKey() == BaseBobSled.KEY_JUMP_BOOST) {
      noFill();
      stroke(#778899);
      strokeWeight(3);
      rect(22, groundLevel + 15, jumpGenerator.getAdjustedImageWidth() + 215, jumpGenerator.getAdjustedImageHeight() + 40);
    }
    noStroke();
    //Jump Boost HUD
    jumpGenerator.drawImage(30, groundLevel + 25);
    textAlign(LEFT, TOP);
    text("Jump Boost", 30 + jumpGenerator.getAdjustedImageWidth() + 10, groundLevel + 25);
    fill(#778899);
    textAlign(CENTER, TOP);
    text("x" + player.getJumpBoostCount(), 30, groundLevel + 25 + jumpGenerator.getAdjustedImageHeight(), jumpGenerator.getAdjustedImageWidth() + 210, 30);




    if (player.getEquippedItemKey() == BaseBobSled.KEY_FLAMETHROWER) {
      noFill();
      stroke(#778899);
      strokeWeight(3);
      rect(292, groundLevel + 15, flameGenerator.getAdjustedImageWidth() + 215, flameGenerator.getAdjustedImageHeight() + 40);
    }
    noStroke();
    //Flamethrower HUD
    flameGenerator.drawImage(300, groundLevel + 25);
    fill(248, 120, 0);
    textAlign(LEFT, TOP);
    text("Flame Ammo", 300 + flameGenerator.getAdjustedImageWidth() + 10, groundLevel + 25);
    fill(#778899);
    textAlign(CENTER, TOP);
    text("x" + player.getFlamethrowerAmmoCount(), 300, groundLevel + 25 + flameGenerator.getAdjustedImageHeight(), flameGenerator.getAdjustedImageWidth() + 210, 30);
  }

  private void advanceToNextLevel() {
    levelPassed = true;
    performCleanup(); 

    Map<String, Object> transitionDict = new HashMap();
    transitionDict.put(ScreenChangeDelegate.KEY_SELECTED, 
      player instanceof JamaicanBobSled ? PlayerType.JAMAICAN : PlayerType.AMERICAN);
    transitionDict.put(ScreenChangeDelegate.KEY_SCORE, player.getScore());
    transitionDict.put(ScreenChangeDelegate.KEY_TIME_REMAINING, millis() - startMillis);
    transitionDict.put(ScreenChangeDelegate.KEY_HEALTH, player.getHealth());
    transitionDict.put(ScreenChangeDelegate.KEY_COINS, player.getCoinCount());
    delegate.performScreenChange(null, transitionDict);
  }

  private void endGame() {
    performCleanup();
    Map<String, Object> transitionDict = new HashMap();
    transitionDict.put(ScreenChangeDelegate.KEY_GAME_RESULT, GameResult.LOST);
    transitionDict.put(ScreenChangeDelegate.KEY_SELECTED, 
      player instanceof JamaicanBobSled ? PlayerType.JAMAICAN : PlayerType.AMERICAN);
    transitionDict.put(ScreenChangeDelegate.KEY_SCORE, player.getScore());
    transitionDict.put(ScreenChangeDelegate.KEY_COINS, player.getCoinCount());
    transitionDict.put(ScreenChangeDelegate.KEY_HEALTH, max(0, player.getHealth()));
    delegate.performScreenChange(GameScreen.GAME_RESULT, transitionDict);
  }

  private void performCleanup() {
    currentAmbianceAudioPlayer.pause();
  }

  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (handled) performCleanup();
    else {
      //if space is pressed, perform jump.
      //if enter is used to start game, have that occur here (could also occur in mousePressed)
      if ( key == ' ' && !player.isJumping()) {
        player.performJump();
      } else if (key == '1') {
        player.setEquippedItemKey(player.getEquippedItemKey() == BaseBobSled.KEY_JUMP_BOOST ? -1 : BaseBobSled.KEY_JUMP_BOOST);
      } else if (key == '2') {
        player.setEquippedItemKey(player.getEquippedItemKey() == BaseBobSled.KEY_FLAMETHROWER ? - 1 : BaseBobSled.KEY_FLAMETHROWER);
      } else if (keyCode == ENTER || keyCode == RETURN) {
        if (!player.isProjectileEquipped() || activeProjectiles.size() < 5) {
          player.useEquipped();
        }
      }

      return true;
    }
    return false;
  }
}