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
    fill(248, 120, 0);
    
    triangle(getLeftSideX() + getHeight()/4, getTopSideY(), getRightSideX(), getTopSideY() + getHeight()/2,
             getLeftSideX() + getHeight()/4, getBottomSideY());
    fill(248, 192, 0);
    ellipse(getLeftSideX() + getHeight()/4, getTopSideY() + getHeight()/2, getHeight()/2, getHeight());

}

  int damageToPlayer() {
   return 4; 
  }
  int damageToBoss() {
    return 2;
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