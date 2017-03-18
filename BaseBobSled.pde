import java.util.List;
import java.util.ArrayList;

abstract class BaseBobSled {

  final static int KEY_JUMP_BOOST = 0;
  final static int KEY_FLAMETHROWER = 1;
  final static int KEY_SNOWTHROWER = 2;
  final static int KEY_ICETHROWER = 3;
  final static int KEY_SHIELD = 4;

  final int STANDARD_JUMP_VELOCITY = 20;

  private float xPosition;
  private float groundLevel;
  private float sledBottom;
  private boolean performingJump;
  private float jumpVel;
  private float gravity;

  protected int score;
  protected int health;
  private int totalCoins;
  private int totalTimeBoostInSeconds;

  private Map<Integer, List<BaseCollectable>> inventory;
  private int equippedKey = -1;

  private ProjectileDelegate projectileDelegate;

  BaseBobSled(float x, float ground, float gravity, ProjectileDelegate projDelegate) {
    xPosition = x;
    groundLevel = ground;
    sledBottom = groundLevel;
    this.gravity = gravity;
    inventory = new HashMap();
    projectileDelegate = projDelegate;
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
  }

  private void fireProjectile() {
    if (equippedKey == BaseBobSled.KEY_SNOWTHROWER) {
      projectileDelegate.addProjectileToWorld(new SnowballProjectile(getRightX() + 5, getTopY() + getHeight()/2, 6));
    } else {
      List<BaseCollectable> projectileList = inventory.get(equippedKey);
      if (projectileList != null && !projectileList.isEmpty()) {
        BaseCollectable collectable = projectileList.remove(projectileList.size() - 1);
        if (collectable instanceof Projectilable) {
          projectileDelegate.addProjectileToWorld(((Projectilable)collectable).convertToProjectile(getRightX() + 5, getTopY() + getHeight()/2));
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
      jumpVel -= gravity;
      sledBottom = min(sledBottom, groundLevel);
    } else if (performingJump) {
      performingJump = false;
    }
    drawSelf();
  }

  void addToCoinTotal(Coin... coins) {
    for (Coin coin : coins) {
      totalCoins += coin.getValue();
    }
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

  void addToTimeBoostTotal(TimeBoost... timeBoosts) {
    for (TimeBoost timeBoost : timeBoosts) {
      totalTimeBoostInSeconds += timeBoost.getValue();
    }
  }

  int getTimeBoostTotal() {
    return totalTimeBoostInSeconds;
  }

  void addToTotalHealth(Health... hearts) {
    for (Health heart : hearts) {
      health += heart.getValue();
    }
  }

  int getHealth() {
    return health;
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
    health-= projectile.damageToPlayer();
  }

  protected abstract void drawSelf();
  protected abstract float getWidth();
  protected abstract float getHeight();
  abstract void takeDamage();
  abstract void incrementScoreForObstaclePass();
}