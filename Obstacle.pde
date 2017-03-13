class Obstacle implements Collidable {

  private float startPosX;
  private int offset;
  private float groundPosY;
  private float speed;
  private float obstacleWidth;
  private float obstacleHeight;
  CollidableState state;
  //Constructor
  public Obstacle(float posX, float ground, float speedVal, boolean turboRequired) {
    //Complete the constructor for the obstacle class to be initialized with an x position
    startPosX = posX;
    groundPosY = ground;
    speed = speedVal;
    offset = 0;
    obstacleWidth = turboRequired ? random(150, 180) : random(100, 120);
    obstacleHeight = turboRequired ? random(210, 250) : random(150, 200);
    state = CollidableState.NOT_SHOWN;
  }

  public float getLeftSideX() {
    return startPosX - (obstacleWidth/2) - offset;
  }

  public float getRightSideX() {
    return startPosX + (obstacleWidth/2) - offset;
  }

  public float getTopSideY() {
    return groundPosY - obstacleHeight/2;
  }

  public void reset() {
    offset = 0;
    state = CollidableState.NOT_SHOWN;
  }


  //Draw the obstacle
  public void updateForDraw() {
    if (isOnScreen()) {
      //Draw each obstacle as a rectangle using the variables in the class
      stroke(255);
      fill(255);
      ellipse(startPosX - offset, groundPosY, obstacleWidth, obstacleHeight);
    }
    offset+=speed;
  }

  //DEBUG method
  /*public void updateForDisabled() {
    if (isOnScreen()) {
      //Draw each obstacle as a rectangle using the variables in the class
      stroke(255);
      fill(255);
      ellipse(startPosX - offset, groundPosY, obstacleWidth, obstacleHeight);
    }
  }*/


  public boolean didCollide(BaseBobSled player) {
    if (isOnScreen() && state != CollidableState.COLLIDED) { 
      //Must check which is wider, the obstacle or the player. The less wide one (collider) should then be checked to see if
      //it is in between the wider one (collidee)
      float colliderLeftSide = player.getWidth() < obstacleWidth ? player.getPositionX() : getLeftSideX();
      float collideeLeftSide = player.getWidth() < obstacleWidth ? getLeftSideX() : player.getPositionX();
      float colliderRightSide = player.getWidth() < obstacleWidth ? player.getRightX() : getRightSideX();
      float collideeRightSide = player.getWidth() < obstacleWidth ? getRightSideX() : player.getRightX();

      boolean collided = player.getSledBottom() > getTopSideY() && 
        ((colliderRightSide > collideeLeftSide && colliderRightSide < collideeRightSide) ||
        (colliderLeftSide > collideeLeftSide && colliderLeftSide < collideeRightSide));

      if (collided) {
        state = CollidableState.COLLIDED;
        //println("Collision detected - Sled bottom greater than obstacle: " + (player.getSledBottom() > getTopSideY()) + 
        //        ". Sled right side caught: " + (player.getRightX() > getLeftSideX() && player.getRightX() < getRightSideX()) +
        //        ". Sled left side caught: " + (player.getPositionX() > getLeftSideX() && player.getPositionX() < getRightSideX()));
        //println("Left side of obstacle is: " + getLeftSideX() + ", Right side of obstacle is: " + getRightSideX() + ". Runner left is at: " + player.getPositionX());
      }
      return collided;
    }

    return false;
  }

  public boolean didPassPlayer(BaseBobSled player) {
    if (state != CollidableState.COLLIDED && state != CollidableState.PASSED && getRightSideX() < player.getPositionX()) {
      state = CollidableState.PASSED;
      return true;
    }

    return false;
  }

  public boolean isOnScreen() {
    boolean onScreen =  (0 < getLeftSideX() && getLeftSideX() < width) || (0 < getRightSideX() && getRightSideX() < width);
    if (state == CollidableState.NOT_SHOWN && onScreen) {
      state = CollidableState.SHOWN;
    }
    return onScreen;
  }
}  