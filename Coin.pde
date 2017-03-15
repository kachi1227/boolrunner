class Coin extends BaseCollectable {

  private float startPosX;
  private float groundPosY;
  private float distanceFromGround;
  
  private CoinEightBitImageGenerator imageGenerator;

  AudioPlayer collectionSoundPlayer;

  public Coin(float posX, float ground, float distanceFromGround, float speed) {
    super(speed);
    startPosX = posX;
    groundPosY = ground;
    this.distanceFromGround = distanceFromGround;
    imageGenerator = new CoinEightBitImageGenerator(2.5); //doesnt work with 10. figure out why...xz

    Minim minim = new Minim(BoolRunnings.this);
    collectionSoundPlayer = minim.loadFile("coin_collect.mp3");
    collectionSoundPlayer.setGain(-15);
  }


  public void updateForDraw() {
    if (isOnScreen() && !isCollected()) drawCoin();
    updateOffset();
  }

  private void drawCoin() {
    float coinLeft = startPosX - getOffset();
    float coinTop = groundPosY - distanceFromGround;
    imageGenerator.drawImage(coinLeft, coinTop);
    ////34x34
    //noStroke();
    //fill(253, 240, 53);
    //rect(coinLeft + 4, coinTop + 2, 26, 30); 
    //fill(219, 138, 53);
    //rect(coinLeft + 26, coinTop + 2, 2, 2); 
    //rect(coinLeft + 28, coinTop + 4, 2, 2); 
    //rect(coinLeft + 30, coinTop + 6, 2, 22); 
    //rect(coinLeft + 28, coinTop + 28, 2, 2); 
    //rect(coinLeft + 26, coinTop + 30, 2, 2);
    //fill(249, 249, 174);  
    //rect(coinLeft + 6, coinTop + 2, 2, 2); 
    //rect(coinLeft + 4, coinTop + 4, 2, 2); 
    //rect(coinLeft + 2, coinTop + 6, 2, 22); 
    //rect(coinLeft + 4, coinTop + 28, 2, 2); 
    //rect(coinLeft + 6, coinTop + 30, 2, 2);
    //fill(249, 178, 80);
    //rect(coinLeft, coinTop + 6, 2, 22); 
    //fill(#ff0000);
    //rect(coinLeft + 2, coinTop + 4, 2, 2); 
    //fill(249, 178, 80);
    //rect(coinLeft + 4, coinTop + 2, 2, 2); 
    //rect(coinLeft + 6, coinTop, 22, 2); 
    //rect(coinLeft + 28, coinTop + 2, 2, 2); 
    //rect(coinLeft + 30, coinTop + 4, 2, 2); 
    //rect(coinLeft + 32, coinTop + 6, 2, 22);
    //rect(coinLeft + 30, coinTop + 28, 2, 2);     
    //rect(coinLeft + 28, coinTop + 30, 2, 2); 
    //rect(coinLeft + 6, coinTop + 32, 22, 2); 
    //rect(coinLeft + 4, coinTop + 30, 2, 2);         
    //rect(coinLeft + 2, coinTop + 28, 2, 2);    
    //fill(252, 174, 82);
    //rect(coinLeft + 12, coinTop + 10, 2, 15);
    //rect(coinLeft + 14, coinTop + 17, 2, 2);
    //rect(coinLeft + 16, coinTop + 15, 2, 2);
    //rect(coinLeft + 18, coinTop + 13, 2, 2);
    //rect(coinLeft + 20, coinTop + 11, 2, 2);
    //rect(coinLeft + 16, coinTop + 19, 2, 2);
    //rect(coinLeft + 18, coinTop + 21, 2, 2);
    //rect(coinLeft + 20, coinTop + 23, 2, 2);
  }

  public float getLeftSideX() {
    return startPosX - getOffset();
  }

  public float getRightSideX() {
    return startPosX + getWidth() - getOffset();
  }

  public float getTopSideY() {
    return groundPosY - distanceFromGround;
  }

  public float getBottomSideY() {
    return groundPosY - distanceFromGround + getHeight();
  }
  
  float getWidth() {
    return imageGenerator.getAdjustedImageWidth();
  }
  
  float getHeight() {
    return imageGenerator.getAdjustedImageHeight();
  }
  
  void onCollided(BaseBobSled player) {
        println("collided boy");
        collectionSoundPlayer.play();
        player.addToCoinTotal(this);    
  }

  int getValue() {
    return 20;
  }
}