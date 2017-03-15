class TimeBoost extends BaseCollectable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;
  private HourGlassEightBitImageGenerator imageGenerator;

  public TimeBoost(float posX, float ground, float distanceFromGround, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    imageGenerator = new HourGlassEightBitImageGenerator(4);
  }


  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawHourGlass();
    updateOffset();
  }

  private void drawHourGlass() {
    float glassLeft = startPosX - getOffset();
    float glassTop = groundPosY - distanceFromGround;
    imageGenerator.drawImage(glassLeft, glassTop);
    glassLeft += 200;
    //30x46
    noStroke();
    fill(255);
    rect(glassLeft + 4, glassTop + 6, 22, 10);
    rect(glassLeft + 10, glassTop + 16, 10, 6);
    rect(glassLeft + 14, glassTop + 22, 2, 4);
    rect(glassLeft + 8, glassTop + 26, 14, 6);
    rect(glassLeft + 6, glassTop + 32, 18, 4);
    rect(glassLeft + 4, glassTop + 36, 22, 4); 

    fill(112, 112, 112);
    rect(glassLeft + 10, glassTop +8, 14, 2);
    rect(glassLeft + 12, glassTop + 10, 10, 2);
    rect(glassLeft + 14, glassTop + 12, 6, 2);
    rect(glassLeft + 16, glassTop + 14, 2, 2);
    rect(glassLeft + 16, glassTop + 36, 2, 2);
    rect(glassLeft + 14, glassTop + 38, 6, 2);

    fill(88, 88, 88);
    rect(glassLeft + 6, glassTop +8, 4, 2);
    rect(glassLeft + 8, glassTop + 10, 4, 2);
    rect(glassLeft + 10, glassTop + 12, 4, 2);
    rect(glassLeft + 12, glassTop +14, 4, 2);

    rect(glassLeft + 14, glassTop + 18, 2, 2);

    rect(glassLeft + 14, glassTop + 28, 2, 2);

    rect(glassLeft + 14, glassTop + 34, 2, 2);
    rect(glassLeft + 12, glassTop + 36, 4, 2);
    rect(glassLeft + 10, glassTop + 38, 4, 2);

    fill(#A68064);
    rect(glassLeft, glassTop, 30, 6);
    rect(glassLeft + 2, glassTop + 6, 2, 8);
    rect(glassLeft + 26, glassTop + 6, 2, 8);

    rect(glassLeft + 4, glassTop + 12, 2, 4);
    rect(glassLeft + 24, glassTop + 12, 2, 4);

    rect(glassLeft + 6, glassTop + 14, 2, 4);
    rect(glassLeft + 22, glassTop + 14, 2, 4);

    rect(glassLeft + 8, glassTop + 16, 2, 4);
    rect(glassLeft + 20, glassTop + 16, 2, 4);

    rect(glassLeft + 10, glassTop + 18, 2, 4);
    rect(glassLeft + 18, glassTop + 18, 2, 4);

    rect(glassLeft + 12, glassTop + 20, 2, 6);
    rect(glassLeft + 16, glassTop + 20, 2, 6);

    rect(glassLeft + 10, glassTop + 24, 2, 4);
    rect(glassLeft + 18, glassTop + 24, 2, 4);

    rect(glassLeft + 8, glassTop + 26, 2, 4);
    rect(glassLeft + 20, glassTop + 26, 2, 4);

    rect(glassLeft + 6, glassTop + 28, 2, 4);
    rect(glassLeft + 22, glassTop + 28, 2, 6);

    rect(glassLeft + 4, glassTop + 30, 2, 6);
    rect(glassLeft + 24, glassTop + 32, 2, 4);

    rect(glassLeft + 2, glassTop + 34, 2, 6);
    rect(glassLeft + 26, glassTop + 34, 2, 6);
    rect(glassLeft, glassTop + 40, 30, 6);

    fill(#CD853F);
    rect(glassLeft + 2, glassTop + 2, 26, 2);
    rect(glassLeft + 2, glassTop + 42, 26, 2);
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