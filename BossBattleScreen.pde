class BossBattleScreen extends BaseGameScreen {
  final float WORLD_GRAVITY = 0.75;

  int cloudX;
  float treeOneX;
  float treeTwoX;

  int runnerX;

  BaseBobSled player;
  List<BaseProjectile> activeProjectiles;

  BaseBoss boss;

  CoinEightBitImageGenerator coinGenerator;
  FlameEightBitImageGenerator flameGenerator;
  HeartEightBitImageGenerator heartGenerator;

  AudioPlayer bossAmbianceAudioPlayer;

  PFont hudFont;

  BossBattleScreen(ScreenChangeDelegate delegate) {
    super(delegate);
    activeProjectiles = new ArrayList();
    loadMusicFiles();
    initHUDElements();
  }

  private void loadMusicFiles() {
    Minim minim = new Minim(BoolRunnings.this);
    bossAmbianceAudioPlayer = minim.loadFile("boss_battle_music.mp3");
    bossAmbianceAudioPlayer.setGain(-20);
  }

  private void initHUDElements() {
    hudFont = createFont("slkscre.ttf", 24);
    coinGenerator = new CoinEightBitImageGenerator(1.5);
    flameGenerator = new FlameEightBitImageGenerator(1.5);
    heartGenerator = new HeartEightBitImageGenerator(2);
  }

  void reset(Map<String, Object> gameStateValues) {
    super.reset(gameStateValues);
    cloudX = width;
    treeOneX = width - 200;
    treeTwoX = 2 * width - 400;

    runnerX = 15;
    groundLevel = height - 100;
    if (gameStateValues != null) {
      //set player, set music
      PlayerType playerType = (PlayerType)gameStateValues.get(ScreenChangeDelegate.KEY_SELECTED);
      configureForSelectedPlayer(playerType);
    }
    player.reset();
    FlameThrowerAmmo ammo = new FlameThrowerAmmo(0, groundLevel, 100, speed);
    for (int i=0; i < 50; i++) player.addToFlamethrowerAmmo(ammo);
  }

  private void configureForSelectedPlayer(PlayerType playerType) {
    if (bossAmbianceAudioPlayer != null) {
      bossAmbianceAudioPlayer.pause();
    }
    ProjectileDelegate projDelegate = new ProjectileDelegate() {
      public void addProjectileToWorld(BaseProjectile projectile) {
        addProjectileToActiveList(projectile);
      }
    };
    WorldAwarenessDelegate intelDelegate = new WorldAwarenessDelegate() {
      public boolean isProjectileWithinDistance(float distance) {
        boolean inDanger = false;
        for (BaseProjectile projectile : activeProjectiles) {
          //float test = dist(projectile.getRightSideX(), projectile.getTopSideY(), boss.getLeftX(), boss.getTopY());
          //println(test);
          if (Math.abs(projectile.getRightSideX() - boss.getLeftX()) <= distance && 
            projectile.intersectsTwoPointsOnYAxis(boss.getTopY(), boss.getBottomY())) {
            inDanger = true;
            break;
          }
        }
        return inDanger;
      }

      public boolean areProjectilesAbove() {
        return false;
      }
      
      public float getPlayerHealth() {
       return player.getHealth(); 
      }
    };
    if (playerType == PlayerType.JAMAICAN) {
      player = new JamaicanBobSled(runnerX, groundLevel, WORLD_GRAVITY, projDelegate);
      boss = new EnglishBoss(width - runnerX, groundLevel, WORLD_GRAVITY, intelDelegate, projDelegate);
    } else {
      player = new AmericanBobSled(runnerX, groundLevel, WORLD_GRAVITY, projDelegate);
      boss = new RussianBoss(width - runnerX, groundLevel, WORLD_GRAVITY, intelDelegate, projDelegate);
    }
    player.enableSnowthrower(true);
    bossAmbianceAudioPlayer.cue(0);
    //bossAmbianceAudioPlayer.loop();
  }

  private void addProjectileToActiveList(BaseProjectile projectile) {
    activeProjectiles.add(projectile);
  }

  void drawScreen() {
    //println(frameRate);
    drawBackground();
    drawCloud();    
    drawTrees();

    player.updateForDrawAtPosition();
    boss.updateForDrawAtPosition();

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
      /*for (Obstacle obstacle : visibleObstacles) {
       if (projectile.getBottomSideY() > obstacle.getTopSideY()) {
       if (!obstacle.isDestroyed() && projectile.didPenetrateHitRect(obstacle.getLeftSideX(), obstacle.getTopSideY(), obstacle.getRightSideX(), groundLevel)) {
       obstacle.destroy();
       activeProjectiles.remove(projectile);
       player.incrementScoreForProjectileHit();
       }
       }
       }*/
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
    textFont(hudFont);
    fill(#778899);
    textSize(32);

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
      rect(295, groundLevel + 15, flameGenerator.getAdjustedImageWidth() + 210, flameGenerator.getAdjustedImageHeight() + 40);
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

    /*    if (player.getEquippedItemKey() == BaseBobSled.KEY_JUMP_BOOST) {
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
     text("x" + player.getJumpBoostCount(), 650, groundLevel + 25 + jumpGenerator.getAdjustedImageHeight(), jumpGenerator.getAdjustedImageWidth() + 210, 30);*/
  }


  private void performCleanup() {
    bossAmbianceAudioPlayer.pause();
  }

  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (!handled) {
      if ( key == ' ' && !player.isJumping()) {
        player.performJump();
        boss.notifyOfPlayerJump();
      } else if (key == '1') {
        player.setEquippedItemKey(player.getEquippedItemKey() == BaseBobSled.KEY_FLAMETHROWER ? - 1 : BaseBobSled.KEY_FLAMETHROWER);
      } else if (key == '2') {
        player.setEquippedItemKey(BaseBobSled.KEY_SNOWTHROWER);
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