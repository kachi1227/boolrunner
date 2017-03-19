class Icicle extends BaseCollectable implements Projectilable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;

  private IceEightBitImageGenerator imageGenerator;

  public Icicle(float posX, float ground, float distanceFromGround, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    imageGenerator = new IceEightBitImageGenerator(2);
  }

  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawIceCube();
    updateOffset();
  }

  private void drawIceCube() {
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
    player.addToIcicles(this);
  }

  public int getValue() {
    return 2;
  }
  
  public BaseProjectile convertToProjectile(float xStartPos, float yStartPos) {
    return new IcicleProjectile(xStartPos, yStartPos, 10.5);
  }
}