class JumpBoost extends BaseCollectable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;
  
  JumpArrowEightBitImageGenerator imageGenerator;

  public JumpBoost(float posX, float ground, float distanceFromGround, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    imageGenerator = new JumpArrowEightBitImageGenerator(5);
  }

  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawBoostArrow();
    updateOffset();
  }

  private void drawBoostArrow() {
    float boostLeft = startPosX - getOffset();
    float boostTop = groundPosY - distanceFromGround;
    imageGenerator.drawImage(boostLeft, boostTop);
  }
  
  public float getLeftSideX() {
    return startPosX - getOffset();
  }

  public float getRightSideX() {
    return startPosX + getWidth() - getOffset();
  }

  public float getTopSideY() {
    return groundPosY - distanceFromGround;
  }
  
  public float getBottomSideY() {
    return groundPosY - distanceFromGround + getHeight();
  }

  float getWidth() {
    return imageGenerator.getAdjustedImageWidth();
  }
  
  float getHeight() {
    return imageGenerator.getAdjustedImageHeight();
  }

  void onCollided(BaseBobSled player) {
    
  }

  public int getValue() {
    return 1;
  }
}