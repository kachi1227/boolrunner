class BulletTime extends BaseCollectable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;

  private HourGlassEightBitImageGenerator imageGenerator;

  AudioPlayer collectionSoundPlayer;

  public BulletTime(float posX, float ground, float distanceFromGround, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    imageGenerator = new HourGlassEightBitImageGenerator(2.5);
  }


  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawCoin();
    updateOffset();
  }

  private void drawCoin() {
    float coinLeft = startPosX - getOffset();
    float coinTop = groundPosY - distanceFromGround;
    imageGenerator.drawImage(coinLeft, coinTop);
    ////34x34
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
    collectionSoundPlayer.play();
  }

  int getValue() {
    return 1;
  }
  
  int getDuration() {
   return 10000; 
  }
}