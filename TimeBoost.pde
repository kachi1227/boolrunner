class TimeBoost implements Collectable {

  private float startPosX;
  private int offset;
  private float groundPosY;
  private float speed;

  public TimeBoost(float posX, float ground, float speedVal) {
    startPosX = posX;
    groundPosY = ground;
    speedVal = speed;
    offset = 0;
  }


  public void updateForDraw() {
    drawHourGlass();
  }

  private void drawHourGlass() {
    float glassLeft = startPosX;
    float glassTop = groundPosY - 300;
    //30x46
    noStroke();
    fill(#666666);
    
    rect(glassLeft + 21, glassTop, 3, 3); 
    rect(glassLeft + 18, glassTop + 3, 9, 3); 
    rect(glassLeft + 15, glassTop + 6, 15, 3); 
    rect(glassLeft + 12, glassTop + 9, 21, 3); 
    rect(glassLeft + 9, glassTop + 12, 27, 3); 
    rect(glassLeft + 6, glassTop + 15, 33, 3);
    rect(glassLeft + 3, glassTop + 18, 39, 3); 
        rect(glassLeft, glassTop + 21, 45, 3); 
rect(glassLeft + 12, glassTop + 24, 21, 3); 
rect(glassLeft + 12, glassTop + 27, 21, 3); 

rect(glassLeft + 12, glassTop + 33, 21, 9);

rect(glassLeft + 12, glassTop + 45, 21, 9);

rect(glassLeft + 12, glassTop + 57, 21, 9);

  }

  public boolean didCollect(BaseBobSled player) {
    return false;
  }

  public boolean didCollide(BaseBobSled player) {
    return false;
  }
}