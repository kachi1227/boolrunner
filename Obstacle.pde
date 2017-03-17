class Obstacle extends BaseCollidable {

  private float startPosX;
  private float groundPosY;
  private float obstacleWidth;
  private float obstacleHeight;

  private boolean destroyed;
  private float destructionHeight;

  AudioPlayer collectionSoundPlayer;
  //Constructor
  public Obstacle(float posX, float ground, float speed, boolean turboRequired) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    obstacleWidth = turboRequired ? random(150, 180) : random(75, 80);
    obstacleHeight = turboRequired ? random(210, 250) : random(100, 150);
    Minim minim = new Minim(BoolRunnings.this);
    collectionSoundPlayer = minim.loadFile("collide_obstacle_2.mp3");
    collectionSoundPlayer.setGain(-25);
  }    

  //Draw the obstacle
  public void updateForDraw() {
    updateForDraw(true);
  }

  public void updateForDraw(boolean checkIfOnScreen) {
    if (!checkIfOnScreen || isOnScreen()) {
      //Draw each obstacle as a rectangle using the variables in the class
      stroke(255);
      fill(255);
      
      rect(startPosX - getOffset(), groundPosY - getHeight(), obstacleWidth, getHeight(), 10);
      rect(startPosX - getOffset(), groundPosY - min(10, getHeight()), obstacleWidth, min(10, getHeight()));
    }
    updateOffset();
    if (destroyed) {
      destructionHeight = max(0, destructionHeight - 7);
    }
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
   
   public void reset() {
    super.reset();
    destroyed = false;
    destructionHeight = obstacleHeight;
   }

  public float getLeftSideX() {
    return startPosX - getOffset();
    //return startPosX - (obstacleWidth/2) - getOffset();
  }

  public float getRightSideX() {
    return startPosX + obstacleWidth - getOffset();
    //return startPosX + (obstacleWidth/2) - getOffset();
  }

  public float getTopSideY() {
    return groundPosY - getHeight();
  }
  
  public float getHeight() {
   return destroyed ? destructionHeight : obstacleHeight; 
  }

  public boolean didCollide(BaseBobSled player) {
    if (isOnScreen() && !destroyed && state != CollidableState.COLLIDED) { 
      //Must check which is wider, the obstacle or the player. The less wide one (collider) should then be checked to see if
      //it is in between the wider one (collidee)
      float colliderLeftSide = player.getWidth() < obstacleWidth ? player.getLeftX() : getLeftSideX();
      float collideeLeftSide = player.getWidth() < obstacleWidth ? getLeftSideX() : player.getLeftX();
      float colliderRightSide = player.getWidth() < obstacleWidth ? player.getRightX() : getRightSideX();
      float collideeRightSide = player.getWidth() < obstacleWidth ? getRightSideX() : player.getRightX();

      boolean collided = player.getBottomY() >= getTopSideY() && 
        ((colliderRightSide >= collideeLeftSide && colliderRightSide <= collideeRightSide) ||
        (colliderLeftSide >= collideeLeftSide && colliderLeftSide <= collideeRightSide));

      if (collided) {
        state = CollidableState.COLLIDED;
        collectionSoundPlayer.play();
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
    if (!destroyed && state != CollidableState.COLLIDED && state != CollidableState.PASSED && getRightSideX() < player.getLeftX()) {
      state = CollidableState.PASSED;
      return true;
    }

    return false;
  }
  
  public void destroy() {
   destroyed = true; 
  }
  
  public boolean isDestroyed() {
   return destroyed; 
  }
}  