abstract class BaseCollectable extends BaseCollidable {

  private boolean collected;

  BaseCollectable(float speed) {
    super(speed);
  }

  void reset() {
    super.reset();
    state = null;
    collected = false;
  }

  void markAsCollected() {
    collected = true;
  }

  boolean isCollected() {
    return collected;
  }
  boolean didCollide(BaseBobSled player) {
    if (getRelationToScreen() == Moveable.ON_SCREEN && state != CollidableState.COLLIDED) {
      //Must check which is wider, the obstacle or the player. The less wide one (collider) should then be checked to see if
      //it is in between the wider one (collidee)
      float colliderLeftSide = player.getWidth() < getWidth() ? player.getLeftX() : getLeftSideX();
      float collideeLeftSide = player.getWidth() < getWidth() ? getLeftSideX() : player.getLeftX();
      float colliderRightSide = player.getWidth() < getWidth() ? player.getRightX() : getRightSideX();
      float collideeRightSide = player.getWidth() < getWidth() ? getRightSideX() : player.getRightX();

      boolean xAxisOverlap =  (colliderRightSide >= collideeLeftSide && colliderRightSide <= collideeRightSide) ||
        (colliderLeftSide >= collideeLeftSide && colliderLeftSide <= collideeRightSide);


      //Must check which is taller, the obstacle or the player. The less tall one (collider) should then be checked to see if
      //it is in between the taller one (collidee)
      float colliderTopSide = player.getHeight() < getHeight() ? player.getTopY() : getTopSideY();
      float collideeTopSide = player.getHeight() < getHeight() ? getTopSideY() : player.getTopY();
      float colliderBottomSide = player.getHeight() < getHeight() ? player.getBottomY() : getBottomSideY();
      float collideeBottomSide = player.getHeight() < getHeight() ? getBottomSideY() : player.getBottomY();

      boolean yAxisOverlap = (colliderBottomSide >= collideeTopSide && colliderBottomSide <= collideeBottomSide) ||
        (colliderTopSide >= collideeTopSide && colliderTopSide <= collideeBottomSide);

      boolean collided = xAxisOverlap && yAxisOverlap;

      if (collided) {
        state = CollidableState.COLLIDED;
        onCollided(player);
        markAsCollected();
      }
      return collided;
    }
    
    return false;
  }
  
  void onUsed() {
    
  }
  
  abstract float getBottomSideY();
  abstract float getWidth();
  abstract float getHeight();
  abstract int getValue();
  abstract void onCollided(BaseBobSled player);
}