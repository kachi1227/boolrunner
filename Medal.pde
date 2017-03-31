class Medal extends BaseCollectable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;
  private float stoppingPoint;

  private MedalEightBitImageGenerator imageGenerator;

  AudioPlayer collectionSoundPlayer;

  public Medal(float posX, float ground, float distanceFromGround, float stopPoint, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    stoppingPoint = stopPoint;
    imageGenerator = new MedalEightBitImageGenerator(3);
    Minim minim = new Minim(BoolRunnings.this);
    collectionSoundPlayer = minim.loadFile("coin_collect.mp3");
    collectionSoundPlayer.setGain(-15);
  }

  public void reset() {
    super.reset();
    collectionSoundPlayer.rewind();
  }

  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawCoin();
    if (getLeftSideX() > stoppingPoint) {
      updateOffset();
    }
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
    player.incrementScoreForMedalCollection();
  }

  int getValue() {
    return 20;
  }
}