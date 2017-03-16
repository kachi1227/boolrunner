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
  int obstacleStartIndex = 0;
  Obstacle[] obstacles = new Obstacle[20]; //fixed values..?
  //Coin[] coins = new Coin[3];
  Coin coin;
  Health collectableHealth;
  JumpBoost jumpBoost;
  TimeBoost timeBoost;
  FlameThrowerAmmo flameThrower;

  CoinEightBitImageGenerator coinGenerator;
  FlameEightBitImageGenerator flameGenerator;
  HeartEightBitImageGenerator heartGenerator;
  JumpArrowEightBitImageGenerator jumpGenerator;

  List<BaseProjectile> activeProjectiles;

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
      lastPosition = lastPosition == -1 ? width : (lastPosition + random(900, 1200));
      obstacles[i] = new Obstacle(lastPosition, groundLevel, speed, i > 16);
    }
    activeProjectiles = new ArrayList();
    loadMusicFiles();
    initHUDElements();
    coin = new Coin(100, groundLevel, 300, 0);
    collectableHealth = new Health(100, groundLevel, 300, 0);
    jumpBoost = new JumpBoost(100, groundLevel, 300, 0);
    timeBoost = new TimeBoost(100, groundLevel, 300, 0);
    flameThrower = new FlameThrowerAmmo(100, groundLevel, 300, 0);
  }

  private void loadMusicFiles() {
    minim = new Minim(BoolRunnings.this);
    jamaicanAmbianceAudioPlayer = minim.loadFile("Temperature.mp3");
    jamaicanAmbianceAudioPlayer.setGain(-20);
    americanAmbianceAudioPlayer = minim.loadFile("PartyInTheUSA.mp3");
    americanAmbianceAudioPlayer.setGain(-20);
  }

  private void initHUDElements() {
    hudFont = createFont("slkscre.ttf", 24);
    coinGenerator = new CoinEightBitImageGenerator(1.5);
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
    obstacleStartIndex = 0;
    player.reset();
    timeAllowed = 120;
    startMillis = millis();

    coinsCollected = 0;
  }

  private void configureForSelectedPlayer(PlayerType playerType) {
    if (currentAmbianceAudioPlayer != null) {
      currentAmbianceAudioPlayer.pause();
    }
    ProjectileDelegate projDelegate = new ProjectileDelegate() {
      public void addProjectileToWorld(BaseProjectile projectile) {
        addProjectileToActiveList(projectile);
      }
    };
    if (playerType == PlayerType.JAMAICAN) {
      player = new JamaicanBobSled(runnerX, groundLevel, WORLD_GRAVITY, projDelegate);
      currentAmbianceAudioPlayer = jamaicanAmbianceAudioPlayer;
    } else {
      player = new AmericanBobSled(runnerX, groundLevel, WORLD_GRAVITY, projDelegate);
      currentAmbianceAudioPlayer = americanAmbianceAudioPlayer;
    }
    currentAmbianceAudioPlayer.cue(0);
    currentAmbianceAudioPlayer.loop();
  }

  private void addProjectileToActiveList(BaseProjectile projectile) {
    activeProjectiles.add(projectile);
  }

  void drawScreen() {
    //println(frameRate);
    drawBackground();
    drawCloud();    
    drawTrees();

    coin.updateForDraw();
    coin.didCollide(player);
    collectableHealth.updateForDraw();
    collectableHealth.didCollide(player);
    jumpBoost.updateForDraw();
    jumpBoost.didCollide(player);
    timeBoost.updateForDraw();
    timeBoost.didCollide(player);
    flameThrower.updateForDraw();
    flameThrower.didCollide(player);

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
      } else if (obstacle.onScreenAfterDistance(totalDistanceTravelled)) {
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
    Map<String, BaseProjectile> test = new HashMap();
    for (int i=activeProjectiles.size() - 1; i >= 0; i--) {
      BaseProjectile projectile = activeProjectiles.get(i);
      if (projectile.isOnScreen()) {
        projectile.updateForDraw();
        String projKey = projectile.getTopSideY() + "" + projectile.getHeight();
        if (test.containsKey(projKey)) {
          BaseProjectile mainProjectileAtHeight = test.get(projKey);
          if (projectile.getRightSideX() > mainProjectileAtHeight.getRightSideX()) {
           test.put(projKey, projectile); 
          }
        } else {
          test.put(projKey, projectile);
        }
      } else {
        activeProjectiles.remove(projectile);
      }
    }
    for (BaseProjectile projectile : test.values()) {
      for (Obstacle obstacle : visibleObstacles) {
       if (projectile.getBottomSideY() > obstacle.getTopSideY()) {
         if (!obstacle.isDestroyed() && projectile.didPenetrateHitRect(obstacle.getLeftSideX(), obstacle.getTopSideY(), obstacle.getRightSideX(), groundLevel)) {
            obstacle.destroy();
            activeProjectiles.remove(projectile);
         }
       }
      }
    }
    
    totalDistanceTravelled += speed;
    drawHUD();
  }

  private void checkForPlayerInteraction(Obstacle obstacle) {
    if (obstacle.didCollide(player)) {
      player.takeDamage();
    } else if (obstacle.didPassPlayer(player)) {
      player.incrementScore();
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
    int currentTime = timeAllowed + player.getTimeBoostTotal() - (int)((millis() - startMillis)/1000);
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
    text("Score: " + player.getScore(), 10, 10);
    //health
    text(player.getHealth(), width - 85, 10);
    heartGenerator.drawImage(width - 120, 13);
    fill(#778899);
    textSize(24);
    //Coin HUD
    coinGenerator.drawImage(30, groundLevel + 25);
    text("Coins", 30 + coinGenerator.getAdjustedImageWidth() + 10, groundLevel + 25);
    fill(#778899);
    textAlign(CENTER, TOP);
    text("x" + player.getCoinCount(), 30, groundLevel + 25 + coinGenerator.getAdjustedImageHeight(), coinGenerator.getAdjustedImageWidth() + 110, 30);

    if (player.getEquippedItemKey() == BaseBobSled.KEY_FLAMETHROWER) {
      noFill();
      stroke(#778899);
      strokeWeight(3);
      rect(295, groundLevel + 15, jumpGenerator.getAdjustedImageWidth() + 235, jumpGenerator.getAdjustedImageHeight() + 40);
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

    if (player.getEquippedItemKey() == BaseBobSled.KEY_JUMP_BOOST) {
      noFill();
      stroke(#778899);
      strokeWeight(3);
      rect(645, groundLevel + 15, jumpGenerator.getAdjustedImageWidth() + 220, jumpGenerator.getAdjustedImageHeight() + 40);
    }
    noStroke();
    //Jump Boost HUD
    jumpGenerator.drawImage(650, groundLevel + 25);
    textAlign(LEFT, TOP);
    text("Jump Boost", 650 + jumpGenerator.getAdjustedImageWidth() + 10, groundLevel + 25);
    fill(#778899);
    textAlign(CENTER, TOP);
    text("x" + player.getJumpBoostCount(), 650, groundLevel + 25 + jumpGenerator.getAdjustedImageHeight(), jumpGenerator.getAdjustedImageWidth() + 210, 30);
  }


  private void performCleanup() {
    currentAmbianceAudioPlayer.pause();
  }

  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (!handled) {
      //println("YOOOO");
      //if space is pressed, perform jump.
      //if enter is used to start game, have that occur here (could also occur in mousePressed)
      if ( key == ' ' && !player.isJumping()) {
        println("day");
        player.performJump();
      } else if (key == '1') {
        println("day2");
        player.setEquippedItemKey(player.getEquippedItemKey() == BaseBobSled.KEY_JUMP_BOOST ? -1 : BaseBobSled.KEY_JUMP_BOOST);
      } else if (key == '2') {
        println("day3");
        player.setEquippedItemKey(player.getEquippedItemKey() == BaseBobSled.KEY_FLAMETHROWER ? - 1 : BaseBobSled.KEY_FLAMETHROWER);
      } else if (keyCode == ENTER || keyCode == RETURN) {
        if (activeProjectiles.size() < 5) {
          player.fireProjectile();
        }
      }

      return true;
    }
    return false;
  }
}