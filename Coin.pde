class Coin implements Collectable {

  private float startPosX;
  private int offset;
  private float groundPosY;
  private float speed;

  public Coin(float posX, float ground, float speedVal) {
    startPosX = posX;
    groundPosY = ground;
    speedVal = speed;
    offset = 0;
  }


  public void updateForDraw() {
    drawCoin();
  }

  private void drawCoin() {
    float coinLeft = startPosX;
    float coinTop = groundPosY - 300;
    //34x34
    noStroke();
    fill(253, 240, 53);
    rect(coinLeft + 4, coinTop + 2, 26, 30); 
    fill(219, 138, 53);
    rect(coinLeft + 26, coinTop + 2, 2, 2); 
    rect(coinLeft + 28, coinTop + 4, 2, 2); 
    rect(coinLeft + 30, coinTop + 6, 2, 22); 
    rect(coinLeft + 28, coinTop + 28, 2, 2); 
    rect(coinLeft + 26, coinTop + 30, 2, 2);
    fill(249, 249, 174);  
    rect(coinLeft + 6, coinTop + 2, 2, 2); 
    rect(coinLeft + 4, coinTop + 4, 2, 2); 
    rect(coinLeft + 2, coinTop + 6, 2, 22); 
    rect(coinLeft + 4, coinTop + 28, 2, 2); 
    rect(coinLeft + 6, coinTop + 30, 2, 2);
    fill(249, 178, 80);
    rect(coinLeft, coinTop + 6, 2, 22); 
    rect(coinLeft + 2, coinTop + 4, 2, 2); 
    rect(coinLeft + 4, coinTop + 2, 2, 2); 
    rect(coinLeft + 6, coinTop, 22, 2); 
    rect(coinLeft + 28, coinTop + 2, 2, 2); 
    rect(coinLeft + 30, coinTop + 4, 2, 2); 
    rect(coinLeft + 32, coinTop + 6, 2, 22);
    rect(coinLeft + 30, coinTop + 28, 2, 2);     
    rect(coinLeft + 28, coinTop + 30, 2, 2); 
    rect(coinLeft + 6, coinTop + 32, 22, 2); 
    rect(coinLeft + 4, coinTop + 30, 2, 2);         
    rect(coinLeft + 2, coinTop + 28, 2, 2);    
    fill(252, 174, 82);
    rect(coinLeft + 12, coinTop + 10, 2, 15);
    rect(coinLeft + 14, coinTop + 17, 2, 2);
    rect(coinLeft + 16, coinTop + 15, 2, 2);
    rect(coinLeft + 18, coinTop + 13, 2, 2);
    rect(coinLeft + 20, coinTop + 11, 2, 2);
    rect(coinLeft + 16, coinTop + 19, 2, 2);
    rect(coinLeft + 18, coinTop + 21, 2, 2);
    rect(coinLeft + 20, coinTop + 23, 2, 2);
  }

  public boolean didCollect(BaseBobSled player) {
    return false;
  }

  public boolean didCollide(BaseBobSled player) {
    return false;
  }
}