class SnowballProjectile extends BaseProjectile {

  private float startPosX;
  private float startPosY;

  SnowballProjectile(float x, float y, float speed) {
    super(speed);
    startPosX = x;
    startPosY = y;
  }

  void updateForDraw() {
    drawSnowball();
    updateOffset();
  }

  void drawSnowball() {
    noStroke();
    fill(255);

    float xStart = getSpeed() < 0 ? getRightSideX() : getLeftSideX();
    float xEnd = getSpeed() < 0 ? getLeftSideX() : getRightSideX();
    int sign = getSpeed() < 0 ? 1 : -1;

    ellipse(xEnd + (sign * getHeight()/2), getTopSideY() + getHeight()/2, getHeight(), getHeight());
    stroke(0xAA6CA6CD);
    line(xStart - (sign * 10), getTopSideY(), xEnd + (sign * (getHeight()/2 + 5)), getTopSideY());
    line(xStart, getTopSideY() + getHeight()/2, xEnd + (sign * (getHeight() + 5)), getTopSideY() + getHeight()/2);
    line(xStart - (sign * 10), getBottomSideY(), xEnd + (sign * (getHeight()/2 + 5)), getBottomSideY());
  }
  
    int damageToPlayer() {
   return 2; 
  }
  int damageToBoss() {
    return 1;
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
    return 48;
  }

  float getHeight() {
    return 24;
  }
}