abstract class BaseCollidable {

  private float offset;
  private float speed;
  CollidableState state;
  BaseCollidable(float speed) {
    this.speed = speed;
    offset = 0;
    state = CollidableState.NOT_SHOWN;
  }

  void setSpeed(float speed) {
    this.speed = speed;
  }

  void updateOffset() {
    offset += speed;
  }

  float getOffset() {
    return offset;
  }

  void reset() {
    offset = 0;
    state = CollidableState.NOT_SHOWN;
  }

  public boolean isOnScreen() {
    boolean onScreen =  (0 < getLeftSideX() && getLeftSideX() < width) || (0 < getRightSideX() && getRightSideX() < width);
    if (state == CollidableState.NOT_SHOWN && onScreen) {
      state = CollidableState.SHOWN;
    }
    return onScreen;
  }

  abstract void updateForDraw();
  abstract float getLeftSideX();
  abstract float getRightSideX();
  abstract float getTopSideY();
  abstract boolean didCollide(BaseBobSled player);
}