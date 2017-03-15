abstract class BaseBobSled {

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
  private int totalJumpBoosts;
  private int totalFlamethrowerAmmo;
  private int totalTimeBoostInSeconds;

  BaseBobSled(float x, float ground, float gravity) {
    xPosition = x;
    groundLevel = ground;
    sledBottom = groundLevel;
    this.gravity = gravity;
    reset();
  }

  void reset() {
    score = 0;
    health = 100;
  }

  public void performJump() {
    //performingJump = true;
    jumpVel = STANDARD_JUMP_VELOCITY;
  }

  public boolean isJumping() {
    return performingJump;
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
    for (JumpBoost jumpBoost : jumpBoosts) {
      totalJumpBoosts += jumpBoost.getValue();
    }
  }
  
  int getJumpBoostCount() {
    return totalJumpBoosts;
  }

  void addToFlamethrowerAmmo(FlameThrowerAmmo... ammo) {
    for (FlameThrowerAmmo throwerAmmo : ammo) {
      totalFlamethrowerAmmo += throwerAmmo.getValue();
    }
  }
  
  int getFlamethrowerAmmoCount() {
   return totalFlamethrowerAmmo; 
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

  protected abstract void drawSelf();
  protected abstract float getWidth();
  protected abstract float getHeight();
  abstract void takeDamage();
  abstract void incrementScore();
}