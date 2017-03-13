class JumpBoost implements Collectable {

  private float startPosX;
  private int offset;
  private float groundPosY;
  private float speed;

  public JumpBoost(float posX, float ground, float speedVal) {
    startPosX = posX;
    groundPosY = ground;
    speedVal = speed;
    offset = 0;
  }


  public void updateForDraw() {
    drawBoostArrow();
  }

  private void drawBoostArrow() {
    float boostLeft = startPosX;
    float boostTop = groundPosY - 300;
    //45x66
    noStroke();
    fill(#00CD00);
    rect(boostLeft + 21, boostTop, 3, 3); 
    rect(boostLeft + 18, boostTop + 3, 9, 3); 
    rect(boostLeft + 15, boostTop + 6, 15, 3); 
    rect(boostLeft + 12, boostTop + 9, 21, 3); 
    rect(boostLeft + 9, boostTop + 12, 27, 3); 
    rect(boostLeft + 6, boostTop + 15, 33, 3);
    rect(boostLeft + 3, boostTop + 18, 39, 3); 
        rect(boostLeft, boostTop + 21, 45, 3); 
rect(boostLeft + 12, boostTop + 24, 21, 3); 
rect(boostLeft + 12, boostTop + 27, 21, 3); 

rect(boostLeft + 12, boostTop + 33, 21, 9);

rect(boostLeft + 12, boostTop + 45, 21, 9);

rect(boostLeft + 12, boostTop + 57, 21, 9);

  }

  public boolean didCollect(BaseBobSled player) {
    return false;
  }

  public boolean didCollide(BaseBobSled player) {
    return false;
  }
}