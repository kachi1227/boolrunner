class Health implements Collectable {

  private float startPosX;
  private int offset;
  private float groundPosY;
  private float speed;

  public Health(float posX, float ground, float speedVal) {
    startPosX = posX;
    groundPosY = ground;
    speedVal = speed;
    offset = 0;
  }


  public void updateForDraw() {
    drawHeart();
  }

  private void drawHeart() {
    float heartLeft = startPosX;
    float heartTop = groundPosY - 300;

    noStroke();
    fill(255, 1, 32);
    rect(heartLeft + 3, heartTop + 3, 6, 18);
    rect(heartLeft + 9, heartTop + 3, 6, 24); 
    rect(heartLeft + 15, heartTop + 6, 9, 27); 
    rect(heartLeft + 24, heartTop + 3, 6, 24); 
    rect(heartLeft + 30, heartTop + 3, 6, 18); 

    fill(#778899);
    rect(heartLeft, heartTop + 6, 3, 12);
    rect(heartLeft + 3, heartTop + 3, 3, 3);
    rect(heartLeft + 6, heartTop, 9, 3);
    rect(heartLeft + 15, heartTop + 3, 3, 3);
    rect(heartLeft + 18, heartTop + 6, 3, 3);
    rect(heartLeft + 21, heartTop + 3, 3, 3);
    rect(heartLeft + 24, heartTop, 9, 3);
    rect(heartLeft + 33, heartTop + 3, 3, 3);
    rect(heartLeft + 36, heartTop + 6, 3, 12);

    //diagonal bottom border
    rect(heartLeft + 3, heartTop + 18, 3, 3);
    rect(heartLeft + 33, heartTop + 18, 3, 3);

    rect(heartLeft + 6, heartTop + 21, 3, 3);
    rect(heartLeft + 30, heartTop + 21, 3, 3);

    rect(heartLeft + 9, heartTop + 24, 3, 3);
    rect(heartLeft + 27, heartTop + 24, 3, 3);

    rect(heartLeft + 12, heartTop + 27, 3, 3);
    rect(heartLeft + 24, heartTop + 27, 3, 3);
    rect(heartLeft + 15, heartTop + 30, 3, 3);
    rect(heartLeft + 21, heartTop + 30, 3, 3);

    rect(heartLeft + 18, heartTop + 33, 3, 3);

    fill(255);
    rect(heartLeft + 6, heartTop + 6, 3, 6);
    rect(heartLeft + 9, heartTop + 6, 3, 3);
  }

  public boolean didCollect(BaseBobSled player) {
    return false;
  }

  public boolean didCollide(BaseBobSled player) {
    return false;
  }
}