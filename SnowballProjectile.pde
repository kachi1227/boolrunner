class SnowballProjectile extends BaseProjectile {

  SnowballProjectile(float x, float y, float speed) {
    super(speed);
  }

  void updateForDraw() {
    updateOffset();
  }

  float getLeftSideX() {
    return 0;
  }

  float getRightSideX() {
    return 0;
  }

  float getTopSideY() {
    return 0;
  }

  float getBottomSideY() {
    return 0;
  }

  float getWidth() {
    return 0;
  }

  float getHeight() {
    return 0;
  }
}