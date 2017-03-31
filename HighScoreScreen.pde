import java.util.regex.Matcher;
import java.util.regex.Pattern;

class GameResultScreen extends BaseGameScreen {

  final static int HIGH_SCORE_CHARACTER_MAX = 11;

  HighScoreEvaluator highScoreEvaluator;
  GameResult gameResult;
  PlayerType playerType;
  int score;
  int coins;
  int health;
  int totalScore;

  boolean allowHighScoreNameInput;
  String playerName;

  AudioPlayer backgroundMusicPlayer;

  GameResultScreen(ScreenChangeDelegate delegate, HighScoreEvaluator evaluator) {
    super(delegate);
    highScoreEvaluator = evaluator;
  }

  void reset(Map<String, Object> gameStateValues) {
    super.reset(gameStateValues);
    if (gameStateValues == null) return;
    gameResult = (GameResult) gameStateValues.get(ScreenChangeDelegate.KEY_GAME_RESULT);
    playerType = (PlayerType) gameStateValues.get(ScreenChangeDelegate.KEY_SELECTED);
    score = (int) gameStateValues.get(ScreenChangeDelegate.KEY_SCORE);
    coins = (int) gameStateValues.get(ScreenChangeDelegate.KEY_COINS);
    health = (int) gameStateValues.get(ScreenChangeDelegate.KEY_HEALTH);
    totalScore = score + (coins * 10) + (health * 15);
    allowHighScoreNameInput = highScoreEvaluator.didCreateNewHighScore(totalScore);
    if (allowHighScoreNameInput) playerName = "";

    Minim minim = new Minim(BoolRunnings.this);
    backgroundMusicPlayer = minim.loadFile(gameResult == GameResult.WON ? "game_won.mp3" : "game_loss.mp3");
    backgroundMusicPlayer.setGain(-20);
    backgroundMusicPlayer.cue(0);
    backgroundMusicPlayer.play();
  }

  void drawScreen() {
    drawBackground();

    //draw the end game screen
    textAlign(CENTER, TOP);
    textFont(getTitleFont());
    textSize(80);
    text(gameResult == GameResult.WON  ? "YOU WON" : "YOU LOST", width/2, 50);
    fill(255);
    textFont(getMainFont());
    textSize(24);
    text(createSubtitleForGameResultAndPlayerType(), width/2, 130);
    textSize(30);
    text(allowHighScoreNameInput ? "Press Enter When Done" : "Press Space to Play Again", width/2, groundLevel - 35);

    textFont(getEightBitFont());
    fill(#778899);
    textSize(32);

    textAlign(LEFT, TOP);
    text("Score: ", width/8, 180);
    text("Coins x 10:", width/8, 220);
    text("Health x 15:", width/8, 260);
    text(allowHighScoreNameInput ? "New High Score:" : "Total Score:", width/8, 310);

    textAlign(RIGHT, TOP);
    text(score, width * 7/8, 180);
    text(coins * 10, width * 7/8, 220);
    text(health * 15, width * 7/8, 260);
    text(totalScore, width * 7/8, 310);
    stroke(#778899);
    strokeWeight(2);
    line(width/8, 300, width * 7/8, 300);

    if (allowHighScoreNameInput) {
      textAlign(LEFT, TOP);
      text("Enter Name: ", width/8, 400);
      textAlign(RIGHT, TOP);
      text(playerName, width/2, 400, width * 3/8, 40);
      line(width/2, 430, width * 7/8, 430);
      textSize(20);
      text(HIGH_SCORE_CHARACTER_MAX - playerName.length(), width * 7/8, 435);
    }

    strokeWeight(1);
    noStroke();
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

  void saveAndGoToHighScoreScreen() {
    highScoreEvaluator.saveScore(totalScore, playerName);
    delegate.performScreenChange(GameScreen.HIGH_SCORE, null);
  }

  boolean handleKeyPressed() {
    if (allowHighScoreNameInput) {
      if (key != CODED) {
        if ((key == RETURN || key == ENTER) && playerName.length() > 0) {
          saveAndGoToHighScoreScreen();
        } else if (keyCode == BACKSPACE || keyCode == DELETE) {
          if (playerName.length() > 0) {
            playerName = playerName.substring(0, playerName.length() - 1);
          }
        } else if (playerName.length() < HIGH_SCORE_CHARACTER_MAX &&
          Pattern.compile("[a-zA-Z_0-9 ]").matcher(String.valueOf(key)).matches()) {
          playerName += key;
        }
      }
    } else {
      boolean handled = super.handleKeyPressed();
      if (!handled) {
        if (key == ' ') {
          delegate.performScreenChange(null, null);
          return true;
        }
      }
    }
    return false;
  }
}