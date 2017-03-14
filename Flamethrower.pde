class FlameThrower implements Collectable {

  private float startPosX;
  private int offset;
  private float groundPosY;
  private float speed;

  public FlameThrower(float posX, float ground, float speedVal) {
    startPosX = posX;
    groundPosY = ground;
    speedVal = speed;
    offset = 0;
  }


  public void updateForDraw() {
    drawCoin();
  }

  private void drawCoin() {
    float flameLeft = startPosX;
    float flameTop = groundPosY - 300;
    //48x32
    noStroke();
    fill(248, 120, 0);
    rect(flameLeft + 28, flameTop, 8, 2); 
    rect(flameLeft + 22, flameTop + 2, 6, 2);
    rect(flameLeft + 18, flameTop + 4, 6, 6);
    rect(flameLeft + 16, flameTop + 6, 2, 2);
    rect(flameLeft + 8, flameTop + 10, 6, 2);
    rect(flameLeft + 20, flameTop + 10, 4, 2);
    rect(flameLeft + 6, flameTop + 12, 14, 2);
    rect(flameLeft + 4, flameTop + 14, 8, 6);
    rect(flameLeft + 2, flameTop + 16, 2, 4);
    rect(flameLeft, flameTop + 16, 2, 2);
    rect(flameLeft + 8, flameTop + 20, 18, 6);

    rect(flameLeft + 6, flameTop + 22, 2, 2);

    rect(flameLeft + 10, flameTop + 26, 6, 2);
    rect(flameLeft + 22, flameTop + 26, 22, 2);
    rect(flameLeft + 24, flameTop + 28, 18, 2);
    rect(flameLeft + 28, flameTop + 30, 10, 2);

    fill(248, 192, 0);
    rect(flameLeft + 28, flameTop + 2, 12, 2); 
    rect(flameLeft + 24, flameTop + 4, 18, 2);
    rect(flameLeft + 22, flameTop + 6, 4, 4);
    rect(flameLeft + 24, flameTop + 10, 2, 2);
    rect(flameLeft + 20, flameTop + 12, 8, 2);
    rect(flameLeft + 8, flameTop + 14, 14, 2);
    rect(flameLeft + 10, flameTop + 16, 6, 2);
    rect(flameLeft + 12, flameTop + 18, 8, 2);
    rect(flameLeft + 16, flameTop + 20, 32, 2);
    rect(flameLeft + 12, flameTop + 22, 2, 2);
    rect(flameLeft + 20, flameTop + 22, 26, 2);
    rect(flameLeft + 10, flameTop + 24, 2, 2);
    rect(flameLeft + 26, flameTop + 24, 20, 2);
    rect(flameLeft + 30, flameTop + 26, 12, 2);
    rect(flameLeft + 30, flameTop + 28, 8, 2);

    fill(248, 248, 0);
    rect(flameLeft + 30, flameTop + 4, 10, 2); 
    rect(flameLeft + 26, flameTop + 6, 18, 2);
    rect(flameLeft + 24, flameTop + 8, 22, 2);
    rect(flameLeft + 26, flameTop + 10, 20, 2);
    rect(flameLeft + 28, flameTop + 12, 20, 2); 
    rect(flameLeft + 22, flameTop + 14, 26, 2);
    rect(flameLeft + 16, flameTop + 16, 32, 2);
    rect(flameLeft + 20, flameTop + 18, 28, 2);
    rect(flameLeft + 24, flameTop + 20, 20, 2);

    rect(flameLeft + 10, flameTop + 22, 2, 2);
    rect(flameLeft + 28, flameTop + 22, 16, 2);
    rect(flameLeft + 12, flameTop + 24, 2, 2);
    rect(flameLeft + 34, flameTop + 24, 8, 2);
    rect(flameLeft + 32, flameTop + 26, 6, 2);
    
    fill(255);
    rect(flameLeft + 32, flameTop + 6, 8, 2);
    rect(flameLeft + 28, flameTop + 8, 16, 2);
    rect(flameLeft + 30, flameTop + 10, 14, 2);
    rect(flameLeft + 32, flameTop + 12, 14, 2);
    rect(flameLeft + 30, flameTop + 14, 16, 2);
    rect(flameLeft + 24, flameTop + 16, 22, 2);
    rect(flameLeft + 26, flameTop + 18, 20, 2);
    rect(flameLeft + 30, flameTop + 20, 14, 2);
    rect(flameLeft + 34, flameTop + 22, 8, 2);

  }

  public boolean didCollect(BaseBobSled player) {
    return false;
  }

  public boolean didCollide(BaseBobSled player) {
    return false;
  }
}