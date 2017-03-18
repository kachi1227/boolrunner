class Shield extends BaseCollectable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;
  private ShieldEightBitImageGenerator imageGenerator;
  AudioPlayer collectionSoundPlayer;

  public Shield(float posX, float ground, float distanceFromGround, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    imageGenerator = new ShieldEightBitImageGenerator(2);
    Minim minim = new Minim(BoolRunnings.this);
    collectionSoundPlayer = minim.loadFile("collide_heart.mp3");
    collectionSoundPlayer.setGain(-15);
  }



  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawShield();
    updateOffset();
  }

  private void drawShield() {
    float glassLeft = startPosX - getOffset();
    float glassTop = groundPosY - distanceFromGround;
    imageGenerator.drawImage(glassLeft, glassTop);
    //30x46
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

  public int getValue() {
    return 3;
  }
}