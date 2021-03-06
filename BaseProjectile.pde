interface ProjectileDelegate {
  void addProjectileToWorld(BaseProjectile projectile);
}

interface Projectilable {
  BaseProjectile convertToProjectile(float xStartPos, float yStartPos);
}

abstract class BaseProjectile implements Moveable {

  private float offset;
  private float speed;
  CollidableState state;
  
  boolean bulletTimeAffected;

  BaseProjectile(float speed) {
    this.speed = speed;
    offset = 0;
  }
  
  public void configureForBulletTimeChange(boolean enabled) {
   bulletTimeAffected = enabled; 
  }

  void setSpeed(float speed) {
    this.speed = speed;
  }

  float getSpeed() {
    float adjustedSpeed = bulletTimeAffected ? speed/4 : speed;
    return adjustedSpeed;
  }

  void updateOffset() {
    offset += getSpeed();
  }

  float getOffset() {
    return offset;
  }

  public int getRelationToScreen() {
    if (getLeftSideX() > width) {
      return Moveable.RIGHT_OF_SCREEN;
    } else if (getLeftSideX() < 0 && getRightSideX() < 0) return Moveable.LEFT_OF_SCREEN;
    else return Moveable.ON_SCREEN;
  }

  public boolean isOnScreen() {
    return getRelationToScreen() == Moveable.ON_SCREEN;
  }

  public boolean didPenetrateHitRect(float x, float y, float rectWidth, float rectHeight) {
    if (isOnScreen() && state != CollidableState.COLLIDED) {
      //Must check which is wider, the obstacle or the player. The less wide one (collider) should then be checked to see if
      //it is in between the wider one (collidee)
      float colliderLeftSide = rectWidth < getWidth() ? x : getLeftSideX();
      float collideeLeftSide = rectWidth < getWidth() ? getLeftSideX() : x;
      float colliderRightSide = rectWidth < getWidth() ? x + rectWidth : getRightSideX();
      float collideeRightSide = rectWidth < getWidth() ? getRightSideX() : x + rectWidth;

      boolean xAxisOverlap =  (colliderRightSide >= collideeLeftSide && colliderRightSide <= collideeRightSide) ||
        (colliderLeftSide >= collideeLeftSide && colliderLeftSide <= collideeRightSide);


      //Must check which is taller, the obstacle or the player. The less tall one (collider) should then be checked to see if
      //it is in between the taller one (collidee)
      float colliderTopSide = rectHeight < getHeight() ? y : getTopSideY();
      float collideeTopSide = rectHeight < getHeight() ? getTopSideY() : y;
      float colliderBottomSide = rectHeight < getHeight() ? y + rectHeight : getBottomSideY();
      float collideeBottomSide = rectHeight < getHeight() ? getBottomSideY() : y + rectHeight;

      boolean yAxisOverlap = (colliderBottomSide >= collideeTopSide && colliderBottomSide <= collideeBottomSide) ||
        (colliderTopSide >= collideeTopSide && colliderTopSide <= collideeBottomSide);

      boolean collided = xAxisOverlap && yAxisOverlap;

      if (collided) {
        state = CollidableState.COLLIDED;
        onPenetration();
      }
      return collided;
    }

    return false;
  }
  
  public boolean intersectsTwoPointsOnYAxis(float topPoint, float bottomPoint) {
     return (getBottomSideY() >= topPoint && getBottomSideY() <= bottomPoint) ||
        (getTopSideY() >= topPoint && getTopSideY() <= bottomPoint);
  }

  void onPenetration() {
  }

  abstract void updateForDraw();
  abstract int damageToPlayer();
  abstract int damageToBoss();
  abstract int pointsPerBossHit();
  abstract float getLeftSideX();
  abstract float getRightSideX();
  abstract float getTopSideY();
  abstract float getBottomSideY();
  abstract float getWidth();
  abstract float getHeight();
}