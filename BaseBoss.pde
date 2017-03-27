abstract class BaseBoss implements Moveable {

  final int STANDARD_JUMP_VELOCITY = 25;
  final int BULLET_TIME_JUMP_VELOCITY = 4;

  private float sledRight;
  private float groundLevel;
  private float sledBottom;
  private boolean performingJump;
  private float jumpVel;
  private float regularGravity;
  private float jumpGravity;
  
  private float speed;

  protected int score;
  protected float health;

  private boolean bulletTimeAffected;

  private boolean defeated;

  private BossIntelligence intelligence;
  private ProjectileDelegate projectileDelegate;

  BaseBoss(float xRight, float ground, float gravity, float speed, WorldAwarenessDelegate intelDelegate, ProjectileDelegate projDelegate) {
    sledRight = xRight;
    groundLevel = ground;
    sledBottom = groundLevel;
    this.regularGravity = gravity;
    this.speed = speed;
    configureIntelligence(intelDelegate);
    projectileDelegate = projDelegate;
    reset();
  }

  private void configureIntelligence(WorldAwarenessDelegate intelDelegate) {
    BossStatusDelegate statusDelegate = new BossStatusDelegate() {
      public float getHealth() {
        return health;
      }

      public boolean isJumping() {
        return BaseBoss.this.isJumping();
      }
    };
    intelligence = new BossIntelligence(statusDelegate, intelDelegate);
  }

  void reset() {
    health = 100;
    defeated = false;
  }

  public void performJump() {
    if (isJumping()) return;

    performingJump = true;
    jumpVel = bulletTimeAffected ? BULLET_TIME_JUMP_VELOCITY : STANDARD_JUMP_VELOCITY;
    jumpGravity = bulletTimeAffected ? regularGravity/25 : regularGravity;
  }

  public boolean isJumping() {
    return performingJump;
  }

  public void fireProjectile() {
    SnowballProjectile projectile = new SnowballProjectile(getLeftX() - 5, getTopY() + getHeight()/2, -8);
    projectile.configureForBulletTimeChange(bulletTimeAffected);
    projectileDelegate.addProjectileToWorld(projectile);
  }

  public float getLeftX() {
    return sledRight - getWidth();
  }

  public float getRightX() {
    return sledRight;
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
      jumpVel -= jumpGravity;
      sledBottom = min(sledBottom, groundLevel);
    } else if (performingJump) {
      performingJump = false;
    }
    drawSelf();
    checkForActions();
  }

  private void checkForActions() {
    int actionsFlag = intelligence.getActionsToPerform();
    if ((actionsFlag & BossAction.JUMP.getFlag()) > 0 && !isJumping()) {
      performJump();
    }
    if ((actionsFlag & BossAction.SHOOT.getFlag()) > 0) fireProjectile();
  }

  public void notifyOfPlayerJump() {
    intelligence.processPlayerJump();
  }

  public float getHealth() {
    return health;
  }

  public void takeDamageFromProjectileHit(BaseProjectile projectile) {
    health-= projectile.damageToBoss();
  }
  
  public void configureForBulletTimeChange(boolean enabled) {
   bulletTimeAffected = enabled;
   intelligence.configureForBulletTimeChange(enabled);
  }

  public void updateSledRight(float newSledRight) {
    sledRight = newSledRight;
  }
  
  public float getSpeed() {
   return speed; 
  }
  
  public void markAsDefeated() {
    defeated = true;
    intelligence.shutdown();
  }
  
  public boolean isDefeated() {
   return defeated; 
  }
  
  public int getRelationToScreen() {
    if (getLeftX() > width) return Moveable.RIGHT_OF_SCREEN;
    else if (getLeftX() < 0 && getRightX() < 0) return Moveable.LEFT_OF_SCREEN;
    else return Moveable.ON_SCREEN;
  }

  protected abstract void drawSelf();
  protected abstract float getWidth();
  protected abstract float getHeight();
}