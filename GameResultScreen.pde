class HighScore {
  int score;
  String name;

  HighScore(int score, String name) {
    this.score = score;
    this.name = name;
  }
}
class HighScoreScreen extends BaseGameScreen {

  HighScoreEvaluator highScoreEvaluator;
  List<HighScore> highScores;

  HighScoreScreen(ScreenChangeDelegate delegate, HighScoreEvaluator evaluator) {
    super(delegate);
    highScoreEvaluator = evaluator;
  }

  void reset(Map<String, Object> gameStateValues) {
    super.reset(gameStateValues);
    highScores = highScoreEvaluator.getHighScoreList();
    printArray(highScores);
  }

  void drawScreen() {
    drawBackground();
    drawInformationalItems();
  }

  private void drawInformationalItems() {
    textFont(getTitleFont());
    fill(255);
    textSize(40);

    textAlign(CENTER, TOP);
    text("High Scores", width/2, 10);
    textFont(getMainFont());
    textSize(30);
    text("Press Space to Play", width/2, groundLevel - 35);
    textFont(getEightBitFont());
    fill(#778899);
    textSize(24);
    for (int i=0, size=highScores.size(); i < size; i++) {
      HighScore highScore = highScores.get(i);
      textAlign(LEFT, TOP);
      text(String.format("%d. %2$s", i + 1, highScore.name), width * .25, 65 + (i * 40));
      textAlign(RIGHT, TOP);
      text(highScore.score, width * .75, 65 + (i * 40));
    }
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