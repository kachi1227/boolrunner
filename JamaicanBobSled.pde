class JamaicanBobSled extends BaseBobSled {

  JamaicanBobSled(float x, float ground, float gravity, WorldInteractionDelegate projDelegate) {
    super(x, ground, gravity, projDelegate);
  }

  protected void drawSelf() {
    float x = getLeftX();
    float sledBottom = getBottomY();
    float sledTop = sledBottom - 40;

    //bob sled
    noStroke();
    fill(0);
    arc(x + 130, sledBottom, 60, 80, PI, 2*PI);
    fill(0, 145, 0);
    rect(x, sledTop, 130, 40);

    //bob sled flag
    stroke(251, 239, 0);
    strokeWeight(8);
    line(x + 3, sledTop + 3.5, x + 127, sledTop + 36.5);
    line(x + 4, sledTop + 36.5, x + 127, sledTop + 3.5);
    fill(251, 239, 0);
    strokeWeight(1);
    triangle(x, sledTop, x, sledTop + 6, x + 5, sledTop);
    triangle(x, sledTop + 40, x, sledTop + 40 - 6, x + 5, sledTop + 40);
    triangle(x + 130, sledTop, x + 130, sledTop + 6, x + 130 - 5, sledTop);
    triangle(x + 130, sledTop + 40, x + 130, sledTop + 40 - 6, x + 130 - 5, sledTop + 40);
    stroke(0);
    fill(0);
    triangle(x, sledTop + 8, x, sledTop + 32, x + 47, sledTop + 20);
    triangle(x + 130, sledTop + 8, x + 130, sledTop + 32, x + 130 - 47, sledTop + 20);


    //person three face
    noStroke();
    fill(#6B4226);
    rect(x + 100, sledBottom - 40 - 18, 25, 18);

    //person two hair
    fill(0);
    arc(x + 100 + 25/2, sledBottom - 40 - 18, 25, 20, PI, 2 * PI);

    //person two eye
    ellipse(x + 120, sledBottom - 40 - 18 + 5, 3, 3);
    //person two mouth
    noFill();
    stroke(0);
    strokeWeight(2);
    line(x + 113, sledBottom - 40 - 18 + 12, x + 113 + 10, sledBottom - 40 - 18 + 12);


    //person two face
    noStroke();
    fill(#6B4226);
    rect(x + 55, sledBottom - 40 - 18, 25, 18);

    //person two hair
    fill(0);
    rect(x + 55, sledBottom - 40 - 18 - 7, 25, 7);

    //person two eye
    ellipse(x + 75, sledBottom - 40 - 18 + 5, 3, 3);
    //person two mouth
    noFill();
    stroke(0);
    strokeWeight(2);
    arc(x + 77, sledBottom - 40 - 18 + 8, 20, 10, PI/2, PI);


    //person three face
    noStroke();
    fill(#6B4226);
    rect(x + 10, sledBottom - 40 - 18, 25, 18);

    //person three hair
    fill(0);
    arc(x + 10 + 25/2, sledBottom - 40 - 18, 25, 20, PI, 2 * PI);
    ellipse(x + 10, sledBottom - 40 - 18 - 6, 6, 6);
    ellipse(x + 10 + 25/4, sledBottom - 40 - 18 - 10, 6, 6);
    ellipse(x + 10 + 25 * .6, sledBottom - 40 - 18 - 11, 6, 6);
    ellipse(x + 10 + 25 * .9, sledBottom - 40 - 18 - 7, 6, 6);

    //person three eye
    ellipse(x + 30, sledBottom - 40 - 18 + 5, 3, 3);
    //person three mouth
    noFill();
    stroke(0);
    strokeWeight(2);
    arc(x + 32, sledBottom - 40 - 18 + 8, 20, 10, PI/2, PI);
    
    
    int shieldAlpha = int(map(shieldResistance, 0, Shield.HITS_PER_SHIELD, 0, 255));
    fill(168, 168, 168, shieldAlpha);
    noStroke();
    arc(x + 130, sledBottom, 60, 80, PI, 2*PI);
    rect(x, sledTop, 130, 40);
  }

  protected float getWidth() {
    return 170;
  }
  protected float getHeight() {
    return 71;
  }

  void takeDamage() {
    health -= 20;
    health = max(0, health);
  }

  void incrementScoreForObstaclePass() {
    score += 100;
  }
}