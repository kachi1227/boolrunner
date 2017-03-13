import java.util.Map;
import ddf.minim.*;

enum GameScreen {
  START, CHOOSE_PLAYER, MAIN, REWARD, HIGH_SCORE;
}

enum PlayerType {
  JAMAICAN, AMERICAN;
}

enum CollidableState {
 NOT_SHOWN, SHOWN, COLLIDED, PASSED; 
}

interface ScreenChangeDelegate {
  String KEY_SCORE = "score";
  String KEY_SELECTED = "selected_player";
  void performScreenChange(Map<String, Object> transitionDict);
  void restart();
}


GameScreen currentScreen = GameScreen.MAIN;
Map<GameScreen, BaseGameScreen> screenMap;

void setup() {
  size(900, 600);
  ScreenChangeDelegate screenDelegate = new ScreenChangeDelegate() {
    public void performScreenChange(Map<String, Object> transitionDict) {
      changeGameScreenFrom(currentScreen, transitionDict);
    }

    public void restart() {
      resetGame();
    }
  };
  screenMap = new HashMap();
  screenMap.put(GameScreen.START, new StartGameScreen(screenDelegate));
  screenMap.put(GameScreen.CHOOSE_PLAYER, new ChoosePlayerScreen(screenDelegate));
  screenMap.put(GameScreen.MAIN, new MainScreen(screenDelegate));
  screenMap.put(GameScreen.REWARD, new RewardScreen(screenDelegate));
  screenMap.put(GameScreen.HIGH_SCORE, new HighScoreScreen(screenDelegate));

  Map<String, Object> transitionMap = null;
  if (currentScreen == GameScreen.MAIN) {
    transitionMap = new HashMap();
    transitionMap.put(ScreenChangeDelegate.KEY_SELECTED, PlayerType.JAMAICAN);
  }
  screenMap.get(currentScreen).reset(transitionMap);
}


void draw() {
  screenMap.get(currentScreen).drawScreen();
}

private void changeGameScreenFrom(GameScreen screen, Map<String, Object> transitionMapping) {
  switch (screen) {
  case START:
    currentScreen = GameScreen.CHOOSE_PLAYER;
    screenMap.get(currentScreen).reset(transitionMapping);
    break;
  case CHOOSE_PLAYER:
    currentScreen = GameScreen.MAIN;
    screenMap.get(currentScreen).reset(transitionMapping);
    break;
  case MAIN:
    break;
  case REWARD:
    break;
  case HIGH_SCORE:
    break;
  }
}

private void resetGame() {
  for (GameScreen screenKey : screenMap.keySet()) {
    screenMap.get(screenKey).reset(null);
    currentScreen = GameScreen.START;
  }
}

/******** INPUT FUNCTIONS ********/
void keyPressed() {
  screenMap.get(currentScreen).handleKeyPressed();
}

void mouseClicked() {
  screenMap.get(currentScreen).handleMouseClicked();
}