class AmericanBobSled extends BaseBobSled {

  AmericanBobSled(float x, float ground, float gravity, WorldInteractionDelegate projDelegate) {
    super(x, ground, gravity, projDelegate);
  }

  protected void drawSelf() {
    float x = getLeftX();
    float sledBottom = getBottomY();
    float sledTop = sledBottom - 40;

    //bob sled
    fill(178, 34, 52);
    noStroke();
    arc(x + 130, sledBottom, 60, 80, PI, 2*PI);
    rect(x, sledTop, 130, 40);

    //bob sled flag
    fill(255);
    for (int i=0; i < 3; i++) {
      rect(x, sledTop + 5.71 + (11.42 * i), 125, 5.71);
    }
    fill(60, 59, 110);
    rect(x, sledTop, 30, 20);
    fill(255);
    for (int i=0; i < 3; i++) {
      int starMax = i % 2 == 0 ? 4 : 3;
      int startOffset = starMax == 4 ? 4 : 8;
      for (int j=0; j < starMax; j++) {
        ellipse(x + startOffset + 1.5 + (j * 6), sledTop + 5 + (i * 6), 3, 3);
      }
    }

    //person one face
    noStroke();
    fill(#FFDEAD);
    rect(x + 100, sledBottom - 40 - 18, 25, 18);

    //person one hair
    fill(#FF8247);
    arc(x + 100 + 25/2, sledBottom - 40 - 18, 25, 20, PI, 2 * PI);
    rect(x + 100, sledBottom - 40 - 20, 10, 15);

    //person one eye
    fill(#8B7765);
    ellipse(x + 120, sledBottom - 40 - 18 + 5, 3, 3);
    //person one mouth
    noFill();
    stroke(#8B7765);
    strokeWeight(2);
    line(x + 113, sledBottom - 40 - 18 + 12, x + 113 + 10, sledBottom - 40 - 18 + 12);


    //person two face
    noStroke();
    fill(#FFDEAD);
    rect(x + 55, sledBottom - 40 - 18, 25, 18);

    //person two hair
    fill(#FFEC8B);
    arc(x + 55 + 25/2, sledBottom - 40 - 18, 25, 20, PI, 2 * PI);
    ellipse(x + 53, sledBottom - 40 - 18, 10, 10);
    rect(x + 55, sledBottom - 40 - 20, 10, 15);

    //person two eye
    fill(#8B7765);
    ellipse(x + 75, sledBottom - 40 - 18 + 5, 3, 3);
    //person two mouth
    noFill();
    stroke(#8B7765);
    strokeWeight(2);
    arc(x + 77, sledBottom - 40 - 18 + 8, 20, 10, PI/2, PI);


    //person three face
    noStroke();
    fill(#DEB887);
    rect(x + 10, sledBottom - 40 - 18, 25, 18);

    //person three hair
    fill(#8B4500);
    arc(x + 10 + 25/2, sledBottom - 40 - 18, 25, 20, PI, 2 * PI);
    ellipse(x + 8, sledBottom - 40 - 18, 10, 10);
    triangle(x + 8, sledBottom - 40 - 18, x + 3, sledBottom - 40 - 2, x + 8, sledBottom - 40 - 2);

    //person three eye
    fill(#8B7765);
    ellipse(x + 30, sledBottom - 40 - 18 + 5, 3, 3);
    //person three mouth
    noFill();
    stroke(#8B7765);
    strokeWeight(2);
    arc(x + 32, sledBottom - 40 - 18 + 8, 20, 10, PI/2, PI);



    int shieldAlpha = int(map(shieldResistance, 0, 3, 0, 255));
    fill(168, 168, 168, shieldAlpha);
    noStroke();
    arc(x + 130, sledBottom, 60, 80, PI, 2*PI);
    rect(x, sledTop, 130, 40);
  }

  protected float getWidth() {
    return 170;
  }
  protected float getHeight() {
    return 68;
  }

  void takeDamage() {
    health -= 25;
    health = max(0, health);
  }

  void incrementScoreForObstaclePass() {
    score += 105;
  }
}