abstract class BaseBoss {

  final int STANDARD_JUMP_VELOCITY = 25;

  private float sledRight;
  private float groundLevel;
  private float sledBottom;
  private boolean performingJump;
  private float jumpVel;
  private float gravity;

  protected int score;
  protected float health;


  private BossIntelligence intelligence;
  private ProjectileDelegate projectileDelegate;

  BaseBoss(float xRight, float ground, float gravity, WorldAwarenessDelegate intelDelegate, ProjectileDelegate projDelegate) {
    sledRight = xRight;
    groundLevel = ground;
    sledBottom = groundLevel;
    this.gravity = gravity;
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
  }

  public void performJump() {
    if (isJumping()) return;

    performingJump = true;
    jumpVel = STANDARD_JUMP_VELOCITY;
  }

  public boolean isJumping() {
    return performingJump;
  }

  public void fireProjectile() {
    projectileDelegate.addProjectileToWorld(new SnowballProjectile(getLeftX() - 5, getTopY() + getHeight()/2, -8));
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
      jumpVel -= gravity;
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

  public void updateSledRight(float newSledRight) {
    sledRight = newSledRight;
  }

  protected abstract void drawSelf();
  protected abstract float getWidth();
  protected abstract float getHeight();
}