abstract class BaseCollidable implements Moveable {

  private float offset;
  private float speed;
  CollidableState state;
  BaseCollidable(float speed) {
    this.speed = speed;
    offset = 0;
  }

  void setSpeed(float speed) {
    this.speed = speed;
  }
  
  void setOffset(float offset) {
   this.offset = offset; 
  }

  void updateOffset() {
    offset += speed;
  }

  float getOffset() {
    return offset;
  }

  void reset() {
    offset = 0;
  }

  public int getRelationToScreen() {
    if (getLeftSideX() > width) return Moveable.RIGHT_OF_SCREEN;
    else if (getLeftSideX() < 0 && getRightSideX() < 0) return Moveable.LEFT_OF_SCREEN;
    else return Moveable.ON_SCREEN;
  }
  
  public boolean isOnScreen() {
   return getRelationToScreen() == Moveable.ON_SCREEN; 
  }
  
  public boolean onScreenAfterDistance(float distanceCovered) {
    float potentialLeftSide = getLeftSideX() + distanceCovered;
    float potentialRightSide = getRightSideX() + distanceCovered;
    return (0 < potentialLeftSide && potentialLeftSide < width) || (0 < potentialRightSide && potentialRightSide < width);
  }

  abstract void updateForDraw();
  abstract float getLeftSideX();
  abstract float getRightSideX();
  abstract float getTopSideY();
  abstract boolean didCollide(BaseBobSled player);
}