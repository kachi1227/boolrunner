class BossBattleScreen extends BaseGameScreen {
  final float WORLD_GRAVITY = 0.75;

  int cloudX;
  float treeOneX;
  float treeTwoX;

  int runnerX;
  int bossX;

  BaseBobSled player;
  List<BaseProjectile> activePlayerProjectiles;

  BaseBoss boss;
  List<BaseProjectile> activeBossProjectiles;

  CoinEightBitImageGenerator coinGenerator;
  FlameEightBitImageGenerator flameGenerator;
  HeartEightBitImageGenerator heartGenerator;

  AudioPlayer bossAmbianceAudioPlayer;

  PFont hudFont;

  BossBattleScreen(ScreenChangeDelegate delegate) {
    super(delegate);
    activePlayerProjectiles = new ArrayList();
    activeBossProjectiles = new ArrayList();
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
    bossX = width - runnerX;
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
    ProjectileDelegate playerProjDelegate = new ProjectileDelegate() {
      public void addProjectileToWorld(BaseProjectile projectile) {
        addProjectileToActiveList(projectile);
      }
    };
    ProjectileDelegate bossProjDelegate = new ProjectileDelegate() {
      public void addProjectileToWorld(BaseProjectile projectile) {
        addProjectileToActiveBossList(projectile);
      }
    };
    WorldAwarenessDelegate intelDelegate = new WorldAwarenessDelegate() {
      public boolean isProjectileWithinStrikingDistance(float distance) {
        boolean inDanger = false;
        for (BaseProjectile projectile : activePlayerProjectiles) {
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

      public PlayerProjectileData getPlayerProjectileData() {
        PlayerProjectileData data = new PlayerProjectileData();
        data.totalCount = activePlayerProjectiles.size();
        for (BaseProjectile projectile : activePlayerProjectiles) {
          if (projectile.getBottomSideY() < boss.getTopY()) data.aboveCount++;
          float dist = dist(projectile.getRightSideX(), projectile.getTopSideY() + projectile.getHeight()/2, boss.getLeftX(), boss.getTopY() + boss.getHeight()/2);
          if (dist < data.closest) data.closest = dist;
          if (dist > data.furthest) data.furthest = dist;
        }
        return data;
      }

      public float getPlayerHealth() {
        return player.getHealth();
      }
    };
    if (playerType == PlayerType.JAMAICAN) {
      player = new JamaicanBobSled(runnerX, groundLevel, WORLD_GRAVITY, playerProjDelegate);
      boss = new EnglishBoss(bossX, groundLevel, WORLD_GRAVITY, intelDelegate, bossProjDelegate);
    } else {
      player = new AmericanBobSled(runnerX, groundLevel, WORLD_GRAVITY, playerProjDelegate);
      boss = new RussianBoss(bossX, groundLevel, WORLD_GRAVITY, intelDelegate, bossProjDelegate);
    }
    player.enableSnowthrower(true);
    bossAmbianceAudioPlayer.cue(0);
    bossAmbianceAudioPlayer.loop();
  }

  private void addProjectileToActiveList(BaseProjectile projectile) {
    activePlayerProjectiles.add(projectile);
  }

  private void addProjectileToActiveBossList(BaseProjectile projectile) {
    activeBossProjectiles.add(projectile);
  }

  void drawScreen() {
    drawBackground();
    drawCloud();    
    drawTrees();
    boss.updateForDrawAtPosition();
    player.updateForDrawAtPosition();


    //we should get box representing first obstacle on screen and see if projectile hits it...
    //keep track of the index with the projectile that's furtherest ahead.
    Map<String, BaseProjectile> heightToPlayerProjectileMap = new HashMap();
    List<BaseProjectile> activeFireProjectiles = new ArrayList();
    for (int i=activePlayerProjectiles.size() - 1; i >= 0; i--) {
      BaseProjectile projectile = activePlayerProjectiles.get(i);
      if (projectile.isOnScreen()) {
        projectile.updateForDraw();
        String projKey = projectile.getTopSideY() + "|" + projectile.getHeight();
        //need additional tracking of fireball projectiles because they can melt snow of enemies.
        //cannot group them with other projectiles
        if (projectile instanceof FireballProjectile) {
          projKey += "F";
          activeFireProjectiles.add(projectile);
        }
        if (heightToPlayerProjectileMap.containsKey(projKey)) {
          BaseProjectile mainProjectileAtHeight = heightToPlayerProjectileMap.get(projKey);
          if (projectile.getRightSideX() > mainProjectileAtHeight.getRightSideX()) {
            heightToPlayerProjectileMap.put(projKey, projectile);
          }
        } else {
          heightToPlayerProjectileMap.put(projKey, projectile);
        }
      } else {
        activePlayerProjectiles.remove(projectile);
      }
    }
    Map<String, BaseProjectile> heightToBossProjectileMap = new HashMap();
    for (int i=activeBossProjectiles.size() - 1; i >= 0; i--) {
      BaseProjectile projectile = activeBossProjectiles.get(i);
      if (projectile.isOnScreen()) {
        projectile.updateForDraw();
        String projKey = projectile.getTopSideY() + "|" + projectile.getHeight();
        if (heightToBossProjectileMap.containsKey(projKey)) {
          BaseProjectile mainProjectileAtHeight = heightToBossProjectileMap.get(projKey);
          if (projectile.getLeftSideX() < mainProjectileAtHeight.getLeftSideX()) {
            heightToBossProjectileMap.put(projKey, projectile);
          }
        } else {
          heightToBossProjectileMap.put(projKey, projectile);
        }
      } else {
        activeBossProjectiles.remove(projectile);
      }
    }
    for (BaseProjectile projectile : heightToPlayerProjectileMap.values()) {

      if (projectile.didPenetrateHitRect(boss.getLeftX(), boss.getTopY(), boss.getWidth(), boss.getHeight())) {
        boss.takeDamageFromProjectileHit(projectile);
        
        
        //the front of boss sled starts at bossX. By the end of it, we want it to be equal to player.getRightSideX()
        //int totalDistance = bossX - player.getRightSideX()
        //if we do bossX - totalDistance = player.getRightSideX()
        //
        float distanceToPlayer = bossX - (player.getRightX() + 200);
        println("Distance to player:" + distanceToPlayer);
        boss.updateSledRight(boss.getHealth() > 70 ? bossX : bossX - (distanceToPlayer * (1 - max(boss.getHealth(), 0)/70.0)));
        activePlayerProjectiles.remove(projectile);
        player.incrementScoreForProjectileHit();
      }
    }

    for (BaseProjectile projectile : heightToBossProjectileMap.values()) {
      if (projectile.didPenetrateHitRect(player.getLeftX(), player.getTopY(), player.getWidth(), player.getHeight())) {
        player.takeDamageFromProjectileHit(projectile);
        activeBossProjectiles.remove(projectile);
      } else {
        for (BaseProjectile fireball : activeFireProjectiles) {
          if (projectile.didPenetrateHitRect(fireball.getLeftSideX(), fireball.getTopSideY(), fireball.getWidth(), fireball.getHeight())) {
            activeBossProjectiles.remove(projectile);
            activePlayerProjectiles.remove(fireball);
          }
        }
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
    textFont(hudFont);
    fill(#778899);
    textSize(32);

    textAlign(CENTER, TOP);
    text("Score: " + player.getScore(), width/2, 10);

    textAlign(LEFT, TOP);
    //health
    text(player.getHealth(), 45, 10);
    heartGenerator.drawImage(10, 13);
    fill(#778899);
    //boss health
    text(int(boss.getHealth()), width - 85, 10);
    heartGenerator.drawImage(width - 120, 13, #333333);

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
        player.setEquippedItemKey(BaseBobSled.KEY_SNOWTHROWER);
      } else if (key == '2') {
        player.setEquippedItemKey(player.getEquippedItemKey() == BaseBobSled.KEY_FLAMETHROWER ? BaseBobSled.KEY_SNOWTHROWER : BaseBobSled.KEY_FLAMETHROWER);
      } else if (key == '3') {
      } else if (key == '4') {
      } else if (key == '5') {
      } else if (keyCode == ENTER || keyCode == RETURN) {
        if (!player.isProjectileEquipped() || activePlayerProjectiles.size() < 5) {
          player.useEquipped();
        }
      }

      return true;
    }
    return false;
  }
}