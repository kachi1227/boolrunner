import java.util.List;
import java.util.ArrayList;

interface WorldInteractionDelegate extends ProjectileDelegate {
  void bulletTimeStatusChange(boolean enabled);
}

abstract class BaseBobSled {

  final static int KEY_JUMP_BOOST = 0;
  final static int KEY_FLAMETHROWER = 1;
  final static int KEY_SNOWTHROWER = 2;
  final static int KEY_ICETHROWER = 3;
  final static int KEY_SHIELD = 4;
  final static int KEY_BULLET_TIME = 5;

  final int STANDARD_JUMP_VELOCITY = 20;

  private float xPosition;
  private float groundLevel;
  private float sledBottom;
  private boolean performingJump;
  private float jumpVel;
  private float gravity;

  protected int score;
  protected int health;
  protected int shieldResistance;
  private int totalCoins;
  private long bulletTimeEndTime = -1;

  private Map<Integer, List<BaseCollectable>> inventory;
  private int equippedKey = -1;

  private WorldInteractionDelegate worldDelegate;

  BaseBobSled(float x, float ground, float gravity, WorldInteractionDelegate worldDelegate) {
    xPosition = x;
    groundLevel = ground;
    sledBottom = groundLevel;
    this.gravity = gravity;
    inventory = new HashMap();
    this.worldDelegate = worldDelegate;
    reset();
  }

  void reset() {
    score = 0;
    health = 100;
    for (Integer inventoryKey : inventory.keySet()) inventory.put(inventoryKey, new ArrayList());
    equippedKey = -1;
  }

  public void performJump() {
    performJump(false);
  }

  private void performJump(boolean useBoost) {
    if (isJumping()) return;

    performingJump = true;
    if (equippedKey == KEY_JUMP_BOOST && useBoost) {
      List<BaseCollectable> jumpBoosts = inventory.get(equippedKey);
      if (jumpBoosts == null || jumpBoosts.isEmpty()) jumpVel = STANDARD_JUMP_VELOCITY;
      else {
        BaseCollectable collectable = jumpBoosts.remove(jumpBoosts.size() - 1);
        jumpVel = STANDARD_JUMP_VELOCITY * 1.25;
        collectable.onUsed();
      }
    } else {
      jumpVel = STANDARD_JUMP_VELOCITY;
    }
  }

  public boolean isJumping() {
    return performingJump;
  }

  public void useEquipped() {
    if (isProjectileEquipped()) fireProjectile();
    else if (equippedKey == KEY_JUMP_BOOST) performJump(true);
    else if (equippedKey == KEY_SHIELD) bolsterShield();
    else if (equippedKey == KEY_BULLET_TIME) startOrExtendBulletTime();
  }

  private void fireProjectile() {
    if (equippedKey == BaseBobSled.KEY_SNOWTHROWER) {
      worldDelegate.addProjectileToWorld(new SnowballProjectile(getRightX() + 5, getTopY() + getHeight()/2, 6));
    } else {
      List<BaseCollectable> projectileList = inventory.get(equippedKey);
      if (projectileList != null && !projectileList.isEmpty()) {
        BaseCollectable collectable = projectileList.remove(projectileList.size() - 1);
        if (collectable instanceof Projectilable) {
          worldDelegate.addProjectileToWorld(((Projectilable)collectable).convertToProjectile(getRightX() + 5, getTopY() + getHeight()/2));
          collectable.onUsed();
        }
        if (projectileList.isEmpty() && inventory.containsKey(BaseBobSled.KEY_SNOWTHROWER)) equippedKey = BaseBobSled.KEY_SNOWTHROWER;
      }
    }
  }

  private boolean isProjectileEquipped() {
    return equippedKey == KEY_FLAMETHROWER || equippedKey == KEY_ICETHROWER
      || equippedKey == KEY_SNOWTHROWER;
  }

  private void bolsterShield() {
    if (equippedKey != KEY_SHIELD) return;
    List<BaseCollectable> shieldsList = inventory.get(equippedKey);
    if (shieldsList != null && !shieldsList.isEmpty()) {
      shieldsList.remove(shieldsList.size() - 1);
      shieldResistance += Shield.HITS_PER_SHIELD;
      equippedKey = BaseBobSled.KEY_SNOWTHROWER;
    }
  }

  private void startOrExtendBulletTime() {
    if (equippedKey != KEY_BULLET_TIME) return;
    List<BaseCollectable> bulletTimeList = inventory.get(equippedKey);
    if (bulletTimeList != null && !bulletTimeList.isEmpty()) {
      BulletTime collectable = (BulletTime)bulletTimeList.remove(bulletTimeList.size() - 1);
      if (bulletTimeEndTime == -1) {
        bulletTimeEndTime = millis() + collectable.getDuration();
        worldDelegate.bulletTimeStatusChange(true);
      } else {
        bulletTimeEndTime += collectable.getDuration();
      }
    }
  }

  public float getLeftX() {
    return xPosition;
  }

  public float getRightX() {
    return xPosition + getWidth();
  }

  public float getBottomY() {
    return sledBottom;
  }

  public float getTopY() {
    return sledBottom - getHeight();
  }

  void updateForDrawAtPosition() {
    if (jumpVel > 0 || sledBottom < groundLevel) {
      sledBottom -= jumpVel;
      jumpVel -= (jumpVel <= 0 && bulletTimeEndTime > -1 ? gravity/25 : gravity);
      sledBottom = min(sledBottom, groundLevel);
    } else if (performingJump) {
      performingJump = false;
    }
    if (bulletTimeEndTime > -1 && millis() > bulletTimeEndTime) {
      bulletTimeEndTime = -1;
      worldDelegate.bulletTimeStatusChange(false);
    }
    drawSelf();
  }

  void addToCoinTotal(Coin... coins) {
    for (Coin coin : coins) {
      totalCoins += coin.getValue();
    }
  }

  void setCoinCount(int coinCount) {
    totalCoins = coinCount;
  }

  int getCoinCount() {
    return totalCoins;
  }


  void addToJumpBoostTotal(JumpBoost... jumpBoosts) {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_JUMP_BOOST);
    if (list == null) {
      list = new ArrayList();
      inventory.put(BaseBobSled.KEY_JUMP_BOOST, list);
    }
    for (JumpBoost jumpBoost : jumpBoosts) {
      list.add(jumpBoost);
    }
  }

  int getJumpBoostCount() {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_JUMP_BOOST);
    return list == null || list.isEmpty() ? 0 : (list.size() * list.get(0).getValue());
  }

  void enableSnowthrower(boolean enabled) {
    if (enabled && !inventory.containsKey(BaseBobSled.KEY_SNOWTHROWER)) {
      inventory.put(BaseBobSled.KEY_SNOWTHROWER, new ArrayList());
    } else if (!enabled) {
      inventory.remove(BaseBobSled.KEY_SNOWTHROWER);
    }
  }

  void addToFlamethrowerAmmo(FlameThrowerAmmo... ammo) {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_FLAMETHROWER);
    if (list == null) {
      list = new ArrayList();
      inventory.put(BaseBobSled.KEY_FLAMETHROWER, list);
    }
    for (FlameThrowerAmmo throwerAmmo : ammo) {
      for (int i=0; i < throwerAmmo.getValue(); i++) {
        list.add(throwerAmmo);
      }
    }
  }

  int getFlamethrowerAmmoCount() {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_FLAMETHROWER);
    return list == null ? 0 : list.size();
  }

  void addToIcicles(Icicle... icicles) {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_ICETHROWER);
    if (list == null) {
      list = new ArrayList();
      inventory.put(BaseBobSled.KEY_ICETHROWER, list);
    }
    for (Icicle icicle : icicles) {
      for (int i=0; i < icicle.getValue(); i++) {
        list.add(icicle);
      }
    }
  }

  int getIcicleCount() {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_ICETHROWER);
    return list == null ? 0 : list.size();
  }

  void addToShields(Shield... shields) {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_SHIELD);
    if (list == null) {
      list = new ArrayList();
      inventory.put(BaseBobSled.KEY_SHIELD, list);
    }
    for (Shield shield : shields) {
      for (int i=0; i < shield.getValue(); i++) {
        list.add(shield);
      }
    }
  }

  int getShieldsCount() {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_SHIELD);
    return list == null ? 0 : list.size();
  }

  void addToBulletTime(BulletTime... bulletTimes) {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_BULLET_TIME);
    if (list == null) {
      list = new ArrayList();
      inventory.put(BaseBobSled.KEY_BULLET_TIME, list);
    }
    for (BulletTime bulletTime : bulletTimes) {
      for (int i=0; i < bulletTime.getValue(); i++) {
        list.add(bulletTime);
      }
    }
  }

  int getBulletTimeCount() {
    List<BaseCollectable> list = inventory.get(BaseBobSled.KEY_BULLET_TIME);
    return list == null ? 0 : list.size();
  }

  void addToTotalHealth(Health... hearts) {
    for (Health heart : hearts) {
      health += heart.getValue();
    }
  }

  void setHealth(int health) {
    this.health = health;
  }

  int getHealth() {
    return health;
  }

  void setScore(int score) {
    this.score = score;
  }

  int getScore() {
    return score;
  }

  void setEquippedItemKey(int inventoryKey) {
    equippedKey = inventoryKey;
  }

  int getEquippedItemKey() {
    return equippedKey;
  }

  void incrementScoreForProjectileHit(BaseProjectile projectile) {
    score += projectile.pointsPerBossHit();
  }

  public void takeDamageFromProjectileHit(BaseProjectile projectile) {
    if (shieldResistance <= 0) health-= projectile.damageToPlayer();
    else {
      shieldResistance--;
    }
  }
  
  void incrementScoreForMedalCollection() {
    score += 1000;
  }

  protected abstract void drawSelf();
  protected abstract float getWidth();
  protected abstract float getHeight();
  abstract void takeDamage();
  abstract void incrementScoreForObstaclePass();
}