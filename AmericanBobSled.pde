class AmericanBobSled extends BaseBobSled {

  AmericanBobSled(float x, float ground, float gravity) {
    super(x, ground, gravity);
  }

  protected void drawSelf() {
    float x = getPositionX();
    float sledBottom = getSledBottom();
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
    rect(x + 100, sledBottom - 40 - 18 - 7, 25, 7);

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
    rect(x + 10, sledBottom - 40 - 18 - 7, 25, 7);

    //person three eye
    fill(#8B7765);
    ellipse(x + 30, sledBottom - 40 - 18 + 5, 3, 3);
    //person three mouth
    noFill();
    stroke(#8B7765);
    strokeWeight(2);
    arc(x + 32, sledBottom - 40 - 18 + 8, 20, 10, PI/2, PI);
  }

  protected float getWidth() {
    return 170;
  }
  protected float getHeight() {
    return 68;
  }
}