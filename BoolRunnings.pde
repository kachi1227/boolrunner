import java.util.Map;
import ddf.minim.*;

enum GameScreen {
  START, CHOOSE_PLAYER, MAIN, INVENTORY, BATTLE, HIGH_SCORE;
}

enum PlayerType {
  JAMAICAN, AMERICAN;
}

enum CollidableState {
  COLLIDED, PASSED;
}

interface Moveable {
  int LEFT_OF_SCREEN = 0;
  int ON_SCREEN = 1;
  int RIGHT_OF_SCREEN = 2;

  int getRelationToScreen();
}

interface ScreenChangeDelegate {
  String KEY_SELECTED = "selected_player";
  String KEY_SCORE = "score";
  String KEY_TIME_REMAINING = "time_remaining";
  String KEY_HEALTH = "health";
  String KEY_COINS = "coins";
  String KEY_INVENTORY = "inventory";
  void performScreenChange(Map<String, Object> transitionDict);
  void restart();
}

GameScreen currentScreen = GameScreen.INVENTORY;
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
  screenMap.put(GameScreen.INVENTORY, new InventorySelectionScreen(screenDelegate));
  screenMap.put(GameScreen.BATTLE, new BossBattleScreen(screenDelegate));
  screenMap.put(GameScreen.HIGH_SCORE, new HighScoreScreen(screenDelegate));

  Map<String, Object> transitionMap = null;
  if (currentScreen == GameScreen.MAIN) {
    transitionMap = new HashMap();
    transitionMap.put(ScreenChangeDelegate.KEY_SELECTED, PlayerType.JAMAICAN);
  } else if (currentScreen == GameScreen.INVENTORY) {
    transitionMap = new HashMap();
    transitionMap.put(ScreenChangeDelegate.KEY_SELECTED, PlayerType.JAMAICAN);
    transitionMap.put(ScreenChangeDelegate.KEY_SCORE, 1650);
    transitionMap.put(ScreenChangeDelegate.KEY_TIME_REMAINING, 60000);
    transitionMap.put(ScreenChangeDelegate.KEY_HEALTH, 55);
    transitionMap.put(ScreenChangeDelegate.KEY_COINS, 300);
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
  case INVENTORY:
    currentScreen = GameScreen.BATTLE;
    screenMap.get(currentScreen).reset(transitionMapping);
    break;
  case BATTLE:
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

void mouseMoved() {
 screenMap.get(currentScreen).handleMouseMoved(); 
}