class RussianBoss extends BaseBoss {

  RussianBoss(float x, float ground, float gravity, float speed, WorldAwarenessDelegate intelDelegate, ProjectileDelegate projDelegate) {
    super(x, ground, gravity, speed, intelDelegate, projDelegate);
  }

  protected void drawSelf() {
    float x = getLeftX();
    float sledBottom = getBottomY();
    float sledTop = sledBottom - 40;

    //bob sled
    fill(213, 43, 30);
    noStroke();
    arc(x + 130, sledBottom, 60, 80, PI, 2*PI);
    rect(x, sledTop, 130, 40);
    fill(0, 57, 166);
    rect(x, sledTop + (40/3), 130, (40/3));
    fill(255);
    rect(x, sledTop, 130, (40/3));
    
    //person one face
    noStroke();
    fill(#FFE4E1);
    rect(x + 100, sledBottom - 40 - 18, 25, 18);

    //person one hair
    fill(#FFEC8B);
    rect(x + 100, sledBottom - 40 - 18 - 7, 25, 7);

    //person one eye
    fill(#666666);
    ellipse(x + 120, sledBottom - 40 - 18 + 5, 3, 3);
    //person one mouth
    noFill();
    stroke(#666666);
    strokeWeight(2);
    line(x + 113, sledBottom - 40 - 18 + 12, x + 113 + 10, sledBottom - 40 - 18 + 12);


    //person two face
    noStroke();
    fill(#FFE4E1);
    rect(x + 55, sledBottom - 40 - 18, 25, 18);

    //person two hair
    fill(#8B4500);
    rect(x + 55, sledBottom - 40 - 18 - 7, 25, 7);


    //person two eye
    fill(#666666);
    ellipse(x + 75, sledBottom - 40 - 18 + 5, 3, 3);
    //person two mouth
    noFill();
    stroke(#666666);
    strokeWeight(2);
    line(x + 68, sledBottom - 40 - 18 + 12, x + 68 + 10, sledBottom - 40 - 18 + 12);
    //person three face
    noStroke();
    fill(#FFE4E1);
    rect(x + 10, sledBottom - 40 - 18, 25, 18);

    //person three hair
    fill(0);
    arc(x + 10 + 25/2, sledBottom - 40 - 18, 25, 20, PI, 2 * PI);
    //person three eye
    fill(#666666);
    ellipse(x + 30, sledBottom - 40 - 18 + 5, 3, 3);
    //person three mouth
    noFill();
    stroke(#666666);
    strokeWeight(2);
    line(x + 23, sledBottom - 40 - 18 + 12, x + 23 + 10, sledBottom - 40 - 18 + 12);
    
}

  protected float getWidth() {
    return 170;
  }
  protected float getHeight() {
    return 68;
  }
}