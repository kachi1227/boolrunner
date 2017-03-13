class HighScoreScreen extends BaseGameScreen {
  
      HighScoreScreen(ScreenChangeDelegate delegate) {
     super(delegate); 
    }

    void drawScreen() {
      drawBackground();
      
        //draw the end game screen
  textAlign(CENTER);
  textSize(26);
//  text("Score: " + score + "/" + obstacles.length, width/2, height/2);
  textSize(18);
  text("Click to Play Again", width/2, height/2 + 25);
  }
  
  boolean handleMouseClicked() {
    return super.handleMouseClicked();
  }
  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (!handled) {
     return true; 
    }
    return false;
  }

}