class FlameThrowerAmmo extends BaseCollectable implements Projectilable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;

  private FlameEightBitImageGenerator imageGenerator;

  AudioPlayer collectionSoundPlayer;

  public FlameThrowerAmmo(float posX, float ground, float distanceFromGround, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    imageGenerator = new FlameEightBitImageGenerator(2);

    Minim minim = new Minim(BoolRunnings.this);
    collectionSoundPlayer = minim.loadFile("collide_flame.mp3");
    collectionSoundPlayer.setGain(-15);
  }


  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawFlame();
    updateOffset();
  }

  private void drawFlame() {
    float flameLeft = startPosX - getOffset();
    float flameTop = groundPosY - distanceFromGround;
    imageGenerator.drawImage(flameLeft, flameTop);
    //48x32
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
    player.addToFlamethrowerAmmo(this);
  }

  public int getValue() {
    return 2;
  }
  
  public BaseProjectile convertToProjectile(float xStartPos, float yStartPos) {
    return new FireballProjectile(xStartPos, yStartPos, 10);
  }
}