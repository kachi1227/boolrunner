class IcicleProjectile extends BaseProjectile {

  private float startPosX;
  private float startPosY;

  IcicleProjectile(float posX, float ground, float speed) {
    super(speed);
    startPosX = posX;
    startPosY = ground;
  }

  void updateForDraw() {
    drawIcicle();
    updateOffset();
  }

  private void drawIcicle() {
    noStroke();
    stroke(#87CEEB);
    fill(0xA0F0FFFF);

    float xStart = getSpeed() < 0 ? getRightSideX() : getLeftSideX();
    float xEnd = getSpeed() < 0 ? getLeftSideX() : getRightSideX();
    int sign = getSpeed() < 0 ? 1 : -1;
    triangle(xStart - (sign * getHeight()/4), getTopSideY(), xEnd, getTopSideY() + getHeight()/2, 
      xStart - (sign * getHeight()/4), getBottomSideY());
    fill(#6CA6CD);
    ellipse(xStart - (sign * getHeight()/4), getTopSideY() + getHeight()/2, getHeight()/2, getHeight());
  }

  int damageToPlayer() {
    return 3;
  }
  int damageToBoss() {
    return 4;
  }
  
    int pointsPerBossHit() {
   return  40;
  }

  float getLeftSideX() {
    return startPosX + getOffset();
  }

  float getRightSideX() {
    return startPosX + getWidth() + getOffset();
  }

  float getTopSideY() {
    return startPosY;
  }

  float getBottomSideY() {
    return startPosY + getHeight();
  }

  float getWidth() {
    return 60;
  }

  float getHeight() {
    return 20;
  }
}