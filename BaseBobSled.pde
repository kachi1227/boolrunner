abstract class BaseBobSled {

  final int STANDARD_JUMP_VELOCITY = 20;

  private float xPosition;
  private float groundLevel;
  private float sledBottom;
  private boolean performingJump;
  private float jumpVel;
  private float gravity;

  BaseBobSled(float x, float ground, float gravity) {
    xPosition = x;
    groundLevel = ground;
    sledBottom = groundLevel;
    this.gravity = gravity;
  }

  public void performJump() {
    //performingJump = true;
    jumpVel = STANDARD_JUMP_VELOCITY;
  }

  public boolean isJumping() {
    return performingJump;
  }
  
  public float getPositionX() {
   return xPosition; 
  }
  
  public float getRightX() {
   return xPosition + getWidth(); 
  }

  public float getSledBottom() {
    return sledBottom;
  }
  
  public float getSledTop() {
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

  protected abstract void drawSelf();
  protected abstract float getWidth();
  protected abstract float getHeight();
}