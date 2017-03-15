class Health extends BaseCollectable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;

  private HeartEightBitImageGenerator imageGenerator;

  public Health(float posX, float ground, float distanceFromGround, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    imageGenerator = new HeartEightBitImageGenerator(3);  
}

  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawHeart();
    updateOffset();
  }

  private void drawHeart() {
    float heartLeft = startPosX - getOffset();
    float heartTop = groundPosY - distanceFromGround;
    imageGenerator.drawImage(heartLeft, heartTop);
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
    return 15;
  }
}