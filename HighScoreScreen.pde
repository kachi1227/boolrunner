class HighScoreScreen extends BaseGameScreen {

  GameResult gameResult;
  PlayerType playerType;
  int score;

  AudioPlayer backgroundMusicPlayer;

  HighScoreScreen(ScreenChangeDelegate delegate) {
    super(delegate);
  }

  void reset(Map<String, Object> gameStateValues) {
    super.reset(gameStateValues);
    if (gameStateValues == null) return;
    gameResult = (GameResult) gameStateValues.get(ScreenChangeDelegate.KEY_GAME_RESULT);
    playerType = (PlayerType) gameStateValues.get(ScreenChangeDelegate.KEY_SELECTED);
    score = (int) gameStateValues.get(ScreenChangeDelegate.KEY_SCORE);
    Minim minim = new Minim(BoolRunnings.this);
    backgroundMusicPlayer = minim.loadFile(gameResult == GameResult.WON ? "game_won.mp3" : "game_loss.mp3");
    backgroundMusicPlayer.setGain(-20);
    backgroundMusicPlayer.cue(0);
    backgroundMusicPlayer.play();
  }

  void drawScreen() {
    drawBackground();

    textFont(getEightBitFont());
    fill(#778899);
    textSize(32);

    textAlign(CENTER, TOP);
    text("Score: " + score, width/2, 10);

    fill(0x90ffffff);
    //draw the end game screen
    textAlign(CENTER, TOP);
    textFont(getTitleFont());
    textSize(100);
    text(gameResult == GameResult.WON  ? "YOU WON" : "YOU LOST", width/2, height/2 - 100);
        fill(255);
    textFont(getMainFont());
    textSize(24);
    text(createSubtitleForGameResultAndPlayerType(), width/2, height/2);
    textSize(30);
    text("Press Space to Play Again", width/2, groundLevel - 35);
  }

  private String createSubtitleForGameResultAndPlayerType() {
    String subtitle = null;
    switch (playerType) {
    case JAMAICAN:
      if (gameResult == GameResult.LOST) {
        subtitle = "Yikes, you didn't even qualify. What Would Usain Do?";
      } else if (gameResult == GameResult.LOST_TO_RIVAL) {
        subtitle = "You lost to Britain. So close, yet so rastafar away.";
      } else if (gameResult == GameResult.WON) {
        subtitle = "Jamaica - 1 | Imperialism - 0";
      }
      break;
    case AMERICAN:
      if (gameResult == GameResult.LOST) {
        subtitle = "Make American Bobsledding Great Again";
      } else if (gameResult == GameResult.LOST_TO_RIVAL) {
        subtitle = "You lost to the Russians. Stop playing like a Clinton";
      } else if (gameResult == GameResult.WON) {
        subtitle = "Another \"Cold\" War victory for the USA!";
      }
      break;
    }
    return subtitle;
  }

  boolean handleMouseClicked() {
    return super.handleMouseClicked();
  }
  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (!handled) {
      if (key == ' ') {
        delegate.performScreenChange(null, null);
        return true;
      }
    }
    return false;
  }
}