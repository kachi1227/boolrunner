interface BitImageGenerator {
  void drawImage(float x, float y);
  float baseImageWidth();
  float baseImageHeight();
  float getScaleFactor();
}

abstract class BaseEightBitImageGenerator implements BitImageGenerator {
  private float scaleFactor;

  BaseEightBitImageGenerator(float scaleFactor) {
    this.scaleFactor = scaleFactor;
  }

  void setScaleFactor(float factor) {
    this.scaleFactor = factor;
  }

  float getScaleFactor() {
    return scaleFactor;
  }
  
  float getAdjustedImageWidth() {
       return baseImageWidth() * getScaleFactor();
  }
  
  float getAdjustedImageHeight() {
       return baseImageHeight() * getScaleFactor(); 
  }
}

class CoinEightBitImageGenerator extends BaseEightBitImageGenerator {

  CoinEightBitImageGenerator(float scaleFactor) {
    super(scaleFactor);
  }

  void drawImage(float x, float y) {
    float factor = getScaleFactor();
    //34x34
    noStroke();
    fill(253, 240, 53);
    rect(x + (2 * factor), y + factor, 13 * factor, 15 * factor); 
    fill(219, 138, 53);
    rect(x + (13 * factor), y + factor, factor, factor); 
    rect(x + (14 * factor), y + (2 * factor), factor, factor); 
    rect(x + (15 * factor), y + (3 * factor), factor, 11 * factor); 
    rect(x + (14 * factor), y + (14 * factor), factor, factor); 
    rect(x + (13 * factor), y + (15 * factor), factor, factor);
    fill(249, 249, 174);  
    rect(x + (3 * factor), y + factor, factor, factor);
    rect(x + (2 * factor), y + (2 * factor), factor, factor);
    rect(x + factor, y + (3 * factor), factor, 11 * factor);
    rect(x + (2 * factor), y + (14 * factor), factor, factor); 
    rect(x + (3 * factor), y + (15 * factor), factor, factor);
    fill(249, 178, 80);
    rect(x, y + (3 * factor), factor, 11 * factor); 
    rect(x + factor, y + (2 * factor), factor, factor);
    rect(x + (2 * factor), y + factor, factor, factor);
    rect(x + (3 * factor), y, 11 * factor, factor);
    rect(x + (14 * factor), y + factor, factor, factor);
    rect(x + (15 * factor), y + (2 * factor), factor, factor);
    rect(x + (16 * factor), y + (3 * factor), factor, 11 * factor);
    rect(x + (15 * factor), y + (14 * factor), factor, factor);   
    rect(x + (14 * factor), y + (15 * factor), factor, factor);
    rect(x + (3 * factor), y + (16 * factor), 11 * factor, factor);
    rect(x + (2 * factor), y + (15 * factor), factor, factor);       
    rect(x + factor, y + (14 * factor), factor, factor);   
    fill(252, 174, 82);
    rect(x + (6 * factor), y + (5 * factor), factor, (7.5 * factor));
    rect(x + (7 * factor), y + (8.5 * factor), factor, factor);
    rect(x + (8 * factor), y + (7.5 * factor), factor, factor);
    rect(x + (9 * factor), y + (6.5 * factor), factor, factor);
    rect(x + (10 * factor), y + (5.5 * factor), factor, factor);
    rect(x + (8 * factor), y + (9.5 * factor), factor, factor);
    rect(x + (9 * factor), y + (10.5 * factor), factor, factor);
    rect(x + (10 * factor), y + (11.5 * factor), factor, factor);
  }

  float baseImageWidth() {
    return 17;
  }

  float baseImageHeight() {
    return 17;
  }
}

class FlameEightBitImageGenerator extends BaseEightBitImageGenerator {
  FlameEightBitImageGenerator(float scaleFactor) {
    super(scaleFactor);
  }

  void drawImage(float x, float y) {
    float factor = getScaleFactor();
    //48x32
    noStroke();
    fill(248, 120, 0);
    rect(x + (14 * factor), y, 4 * factor, factor); 
    rect(x + (11 * factor), y + factor, 3 * factor, factor);
    rect(x + (9 * factor), y + (2 * factor), 3 * factor, 3 * factor);
    rect(x + (8 * factor), y + (3 * factor), factor, factor);
    rect(x + (4 * factor), y + (5 * factor), 6, factor);
    rect(x + (10 * factor), y + (5 * factor), 2 * factor, factor);
    rect(x + (3 * factor), y + (6 * factor), 7 * factor, factor);
    rect(x + (2 * factor), y + (7 * factor), 4 * factor, 3 * factor);
    rect(x + factor, y + (8 * factor), factor, 2 * factor);
    rect(x, y + (8 * factor), factor, factor);
    rect(x + (4 * factor), y + (10 * factor), 9 * factor, 3 * factor);

    rect(x + (3 * factor), y + (11 * factor), factor, factor);

    rect(x + (5 * factor), y + (13 * factor), 3 * factor, factor);
    rect(x + (11 * factor), y + (13 * factor), 11 * factor, factor);
    rect(x + (12 * factor), y + (14 * factor), 9 * factor, factor);
    rect(x + (14 * factor), y + (15 * factor), 5 * factor, factor);

    fill(248, 192, 0);
    rect(x + (14 * factor), y + factor, 6 * factor, factor); 
    rect(x + (12 * factor), y + (2 * factor), 9 * factor, factor);
    rect(x + (11 * factor), y + (3 * factor), 2 * factor, 2 * factor);
    rect(x + (12 * factor), y + (5 * factor), factor, factor);
    rect(x + (10 * factor), y + (6 * factor), 4 * factor, factor);
    rect(x + (4 * factor), y + (7 * factor), 7 * factor, factor);
    rect(x + (5 * factor), y + (8 * factor), 3 * factor, factor);
    rect(x + (6 * factor), y + (9 * factor), 4 * factor, factor);
    rect(x + (8 * factor), y + (10 * factor), 16 * factor, factor);
    rect(x + (6 * factor), y + (11 * factor), factor, factor);
    rect(x + (10 * factor), y + (11 * factor), 13 * factor, factor);
    rect(x + (5 * factor), y + (12 * factor), factor, factor);
    rect(x + (13 * factor), y + (12 * factor), 10 * factor, factor);
    rect(x + (15 * factor), y + (13 * factor), 6 * factor, factor);
    rect(x + (15 * factor), y + (14 * factor), 4 * factor, factor);

    fill(248, 248, 0);
    rect(x + (15 * factor), y + (2 * factor), 5 * factor, factor); 
    rect(x + (13 * factor), y + (3 * factor), 9 * factor, factor);
    rect(x + (12 * factor), y + (4 * factor), 11 * factor, factor);
    rect(x + (13 * factor), y + (5 * factor), 10 * factor, factor);
    rect(x + (14 * factor), y + (6 * factor), 10 * factor, factor); 
    rect(x + (11 * factor), y + (7 * factor), 13 * factor, factor);
    rect(x + (8 * factor), y + (8 * factor), 16 * factor, factor);
    rect(x + (10 * factor), y + (9 * factor), 14 * factor, factor);
    rect(x + (12 * factor), y + (10 * factor), 10 * factor, factor);

    rect(x + (5 * factor), y + (11 * factor), factor, factor);
    rect(x + (14 * factor), y + (11 * factor), 8 * factor, factor);
    rect(x + (6 * factor), y + (12 * factor), factor, factor);
    rect(x + (17 * factor), y + (12 * factor), 4 * factor, factor);
    rect(x + (16 * factor), y + (13 * factor), 3 * factor, factor);

    fill(255);
    rect(x + (16 * factor), y + (3 * factor), 4 * factor, factor);
    rect(x + (14 * factor), y + (4 * factor), 8 * factor, factor);
    rect(x + (15 * factor), y + (5 * factor), 7 * factor, factor);
    rect(x + (16 * factor), y + (6 * factor), 7 * factor, factor);
    rect(x + (15 * factor), y + (7 * factor), 8 * factor, factor);
    rect(x + (12 * factor), y + (8 * factor), 11 * factor, factor);
    rect(x + (13 * factor), y + (9 * factor), 10 * factor, factor);
    rect(x + (15 * factor), y + (10 * factor), 7 * factor, factor);
    rect(x + (17 * factor), y + (11 * factor), 4 * factor, factor);
  }

  float baseImageWidth() {
    return 24;
  }

  float baseImageHeight() {
    return 16;
  }
}

class HeartEightBitImageGenerator extends BaseEightBitImageGenerator {

  HeartEightBitImageGenerator(float scaleFactor) {
    super(scaleFactor);
  }

  void drawImage(float x, float y) {
    float factor = getScaleFactor();

    noStroke();
    fill(255, 1, 32);
    rect(x + factor, y + factor, 2 * factor, 6 * factor);
    rect(x + (3 * factor), y + factor, 2 * factor, 8 * factor); 
    rect(x + (5 * factor), y + (2 * factor), 3 * factor, 9 * factor); 
    rect(x + (8 * factor), y + factor, 2 * factor, 8 * factor); 
    rect(x + (10 * factor), y + factor, 2 * factor, 6 * factor); 

    fill(#778899);
    rect(x, y + (2 * factor), factor, 4 * factor);
    rect(x + factor, y + factor, factor, factor);
    rect(x + (2 * factor), y, 3 * factor, factor);
    rect(x + (5 * factor), y + factor, factor, factor);
    rect(x + (6 * factor), y + (2 * factor), factor, factor);
    rect(x + (7 * factor), y + factor, factor, factor);
    rect(x + (8 * factor), y, 3 * factor, factor);
    rect(x + (11 * factor), y + factor, factor, factor);
    //last pixel on right
    rect(x + (12 * factor), y + (2 * factor), factor, 4 * factor);

    //diagonal bottom border
    rect(x + factor, y + (6 * factor), factor, factor);
    rect(x + (11 * factor), y + (6 * factor), factor, factor);

    rect(x + (2 * factor), y + (7 * factor), factor, factor);
    rect(x + (10 * factor), y + (7 * factor), factor, factor);

    rect(x + (3 * factor), y + (8 * factor), factor, factor);
    rect(x + (9 * factor), y + (8 * factor), factor, factor);

    rect(x + (4 * factor), y + (9 * factor), factor, factor);
    rect(x + (8 * factor), y + (9 * factor), factor, factor);
    rect(x + (5 * factor), y + (10 * factor), factor, factor);
    rect(x + (7 * factor), y + (10 * factor), factor, factor);

    //last pixel on bottom
    rect(x + (6 * factor), y + (11 * factor), factor, factor);

    fill(255);
    rect(x + (2 * factor), y + (2 * factor), factor, (2 * factor));
    rect(x + (3 * factor), y + (2 * factor), factor, factor);
  }

  float baseImageWidth() {
    return 13;
  }

  float baseImageHeight() {
    return 12;
  }
}

class JumpArrowEightBitImageGenerator extends BaseEightBitImageGenerator {

  JumpArrowEightBitImageGenerator(float scaleFactor) {
    super(scaleFactor);
  }

  void drawImage(float x, float y) {
    float f = getScaleFactor();

    //45x66
    noStroke();
    fill(#00CD00);
    rect(x + (7 * f), y, f, f); 
    rect(x + (6 * f), y + f, 3 * f, f); 
    rect(x + (5 * f), y + (2 * f), 5 * f, f); 
    rect(x + (4 * f), y + (3 * f), 7 * f, f); 
    rect(x + (3 * f), y + (4 * f), 9 * f, f); 
    rect(x + (2 * f), y + (5 * f), 11 * f, f);
    rect(x + f, y + (6 * f), 13 * f, f); 
    rect(x, y + (7 * f), 15 * f, f); 
    rect(x + (4 * f), y + (8 * f), 7 * f, f); 
    rect(x + (4 * f), y + (9 * f), 7 * f, f); 

    rect(x + (4 * f), y + (11 * f), 7 * f, 3 * f);

    rect(x + (4 * f), y + (15 * f), 7 * f, 3 * f);

    rect(x + (4 * f), y + (19 * f), 7 * f, 3 * f);
  }

  float baseImageWidth() {
    return 15;
  }

  float baseImageHeight() {
    return 22;
  }
}

class HourGlassEightBitImageGenerator extends BaseEightBitImageGenerator {

  HourGlassEightBitImageGenerator(float scaleFactor) {
    super(scaleFactor);
  }

  void drawImage(float x, float y) {
    float f = getScaleFactor();
    //30x46
    noStroke();
    fill(255);
    rect(x + (2 * f), y + (3 * f), 11 * f, 5 * f);
    rect(x + (5 * f), y + (8 * f), 5 * f, 3 * f);
    rect(x + (7 * f), y + (11 * f), f, 2 * f);
    rect(x + (4 * f), y + (13 * f), 7 * f, 3 * f);
    rect(x + (3 * f), y + (16 * f), 9 * f, 2 * f);
    rect(x + (2 * f), y + (18 * f), 11 * f, 2 * f); 

    fill(112, 112, 112);
    rect(x + (5 * f), y + (4 * f), 7 * f, f);
    rect(x + (6 * f), y + (5 * f), 5 * f, f);
    rect(x + (7 * f), y + (6 * f), 3 * f, f);
    rect(x + (8 * f), y + (7 * f), f, f);
    rect(x + (8 * f), y + (18 * f), f, f);
    rect(x + (7 * f), y + (19 * f), 3 * f, f);

    fill(88, 88, 88);
    rect(x + (3 * f), y + (4 * f), 2 * f, f);
    rect(x + (4 * f), y + (5 * f), 2 * f, f);
    rect(x + (5 * f), y + (6 * f), 2 * f, f);
    rect(x + (6 * f), y + (7 * f), 2 * f, f);

    rect(x + (7 * f), y + (9 * f), f, f);

    rect(x + (7 * f), y + (14 * f), f, f);

    rect(x + (7 * f), y + (17 * f), f, f);
    rect(x + (6 * f), y + (18 * f), 2 * f, f);
    rect(x + (5 * f), y + (19 * f), 2 * f, f);

    fill(#A68064);
    rect(x, y, 15 * f, 3 * f);
    rect(x + f, y + (3 * f), f, 4 * f);
    rect(x + (13 * f), y + (3 * f), f, 4 * f);

    rect(x + (2 * f), y + (6 * f), f, 2 * f);
    rect(x + (12 * f), y + (6 * f), f, 2 * f);

    rect(x + (3 * f), y + (7 * f), f, 2 * f);
    rect(x + (11 * f), y + (7 * f), f, 2 * f);

    rect(x + (4 * f), y + (8 * f), f, 2 * f);
    rect(x + (10 * f), y + (8 * f), f, 2 * f);

    rect(x + (5 * f), y + (9 * f), f, 2 * f);
    rect(x + (9 * f), y + (9 * f), f, 2 * f);

    rect(x + (6 * f), y + (10 * f), f, 3 * f);
    rect(x + (8 * f), y + (10 * f), f, 3 * f);

    rect(x + (5 * f), y + (12 * f), f, 2 * f);
    rect(x + (9 * f), y + (12 * f), f, 2 * f);

    rect(x + (4 * f), y + (13 * f), f, 2 * f);
    rect(x + (10 * f), y + (13 * f), f, 2 * f);

    rect(x + (3 * f), y + (14 * f), f, 2 * f);
    rect(x + (11 * f), y + (14 * f), f, 3 * f);

    rect(x + (2 * f), y + (15 * f), f, 3 * f);
    rect(x + (12 * f), y + (16 * f), f, 2 * f);

    rect(x + f, y + (17 * f), f, 3 * f);
    rect(x + (13 * f), y + (17 * f), f, 3 * f);
    rect(x, y + (20 * f), 15 * f, 3 * f);

    fill(#CD853F);
    rect(x + f, y + f, (13 * f), f);
    rect(x + f, y + (21 * f), (13 * f), f);
  }

  float baseImageWidth() {
    return 15;
  }

  float baseImageHeight() {
    return 23;
  }
}