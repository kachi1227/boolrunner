class TimeBoost extends BaseCollectable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;
  private HourGlassEightBitImageGenerator imageGenerator;
  AudioPlayer collectionSoundPlayer;

  public TimeBoost(float posX, float ground, float distanceFromGround, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    imageGenerator = new HourGlassEightBitImageGenerator(2);
    Minim minim = new Minim(BoolRunnings.this);
    collectionSoundPlayer = minim.loadFile("collide_time.mp3");
    collectionSoundPlayer.setGain(-15);
  }

  public void reset() {
    super.reset();
    collectionSoundPlayer.rewind();
  }


  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawHourGlass();
    updateOffset();
  }

  private void drawHourGlass() {
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
    player.addToTimeBoostTotal(this);
  }

  public int getValue() {
    return 15;
  }
}