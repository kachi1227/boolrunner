class FireballProjectile extends BaseProjectile {

  private float startPosX;
  private float startPosY;

  FireballProjectile(float posX, float ground, float speed) {
    super(speed);
    startPosX = posX;
    startPosY = ground;
  }

  void updateForDraw() {
    drawFireball();
    updateOffset();
  }
  
  private void drawFireball() {
    noStroke();
    fill(248, 120, 0);
    triangle(getLeftSideX(), getTopSideY() + getHeight()/2, getLeftSideX() + (getWidth() * 2/3), getTopSideY(), 
        getOffset() + startPosX + (getWidth() * 2/3), getBottomSideY());
    fill(248, 192, 0);
    ellipse(getRightSideX() - getHeight()/2, getTopSideY() + getHeight()/2, getHeight(), getHeight());
}

  int damageToPlayer() {
   return 4; 
  }
  int damageToBoss() {
    return 2;
  }
  
  int pointsPerBossHit() {
   return  50;
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