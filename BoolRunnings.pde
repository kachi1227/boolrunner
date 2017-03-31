import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;
import ddf.minim.*;

enum GameScreen {
  START, INSTRUCTIONS, CHOOSE_PLAYER, MAIN, INVENTORY, BATTLE, GAME_RESULT, HIGH_SCORE, CREDITS;
}

enum GameResult {
  LOST, LOST_TO_RIVAL, WON;
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
  String KEY_HEALTH = "health";
  String KEY_COINS = "coins";
  String KEY_INVENTORY = "inventory";
  String KEY_GAME_RESULT = "game_result";
  String KEY_PREVIOUS_SCREEN = "previous_screen";
  void performScreenChange(GameScreen toSuggestedScreen, Map<String, Object> transitionDict);
  void restart();
}

interface HighScoreEvaluator {
  boolean didCreateNewHighScore(int score);
  void saveScore(int score, String name);
  List<HighScore> getHighScoreList();
}

final static String HIGH_SCORE_DEST_FILE = "high_scores.json";

GameScreen currentScreen = GameScreen.START;
Map<GameScreen, BaseGameScreen> screenMap;
SortedMap<Integer, List<String>> highScoresMap;


void setup() {
  size(900, 600);
  loadHighScores();
  initGameScreens();
}

private void initGameScreens() {
  ScreenChangeDelegate screenDelegate = new ScreenChangeDelegate() {
    public void performScreenChange(GameScreen toSuggestedScreen, Map<String, Object> transitionDict) {
      changeGameScreenFrom(currentScreen, toSuggestedScreen, transitionDict);
    }

    public void restart() {
      resetGame();
    }
  };
  HighScoreEvaluator scoreEvaluator = new HighScoreEvaluator() {
    public boolean didCreateNewHighScore(int score) {
      return isNewHighScore(score);
    }

    public void saveScore(int score, String name) {
      updateHighScoresMap(score, name);
    }

    public List<HighScore> getHighScoreList() {
      return generateHighScoreList();
    }
  };
  screenMap = new HashMap();
  screenMap.put(GameScreen.START, new StartGameScreen(screenDelegate));
  screenMap.put(GameScreen.INSTRUCTIONS, new InstructionsScreen(screenDelegate));
  screenMap.put(GameScreen.CHOOSE_PLAYER, new ChoosePlayerScreen(screenDelegate));
  screenMap.put(GameScreen.MAIN, new MainScreen(screenDelegate));
  screenMap.put(GameScreen.INVENTORY, new InventorySelectionScreen(screenDelegate));
  screenMap.put(GameScreen.BATTLE, new BossBattleScreen(screenDelegate));
  screenMap.put(GameScreen.GAME_RESULT, new GameResultScreen(screenDelegate, scoreEvaluator));
  screenMap.put(GameScreen.HIGH_SCORE, new HighScoreScreen(screenDelegate, scoreEvaluator));
  screenMap.put(GameScreen.CREDITS, new CreditsScreen(screenDelegate));

  Map<String, Object> transitionMap = null;
  screenMap.get(currentScreen).reset(transitionMap);
}

private void loadHighScores() {
  highScoresMap = new TreeMap();
  JSONArray highScoresJsonArray;
  File highScoreFile = new File(dataPath("high_scores.json"));
  if (highScoreFile.exists()) {
    println("high score file exists");
    highScoresJsonArray = loadJSONArray("high_scores.json");
  } else {
    println("high score file doesnt exists");
    highScoresJsonArray = createAndSaveNewHighScores();
  }
  for (int i=0, size=highScoresJsonArray.size(); i < size; i++) {
    JSONObject highScoreJson = highScoresJsonArray.getJSONObject(i);
    int score = highScoreJson.getInt("score");
    String name = highScoreJson.getString("name");

    List<String> names = highScoresMap.get(score);
    if (names == null) {
      names = new ArrayList(); 
      highScoresMap.put(score, names);
    }
    names.add(name);
  }
}

void draw() {
  screenMap.get(currentScreen).drawScreen();
}

private void changeGameScreenFrom(GameScreen screen, GameScreen toSuggestedScreen, Map<String, Object> transitionMapping) {
  switch (screen) {
  case START:
    if (toSuggestedScreen == null) {
      currentScreen = GameScreen.CHOOSE_PLAYER;
      screenMap.get(currentScreen).reset(transitionMapping);
    } else if (toSuggestedScreen == GameScreen.INVENTORY || toSuggestedScreen == GameScreen.INSTRUCTIONS
      || toSuggestedScreen == GameScreen.HIGH_SCORE || toSuggestedScreen == GameScreen.CREDITS) {
      currentScreen = toSuggestedScreen;
      screenMap.get(currentScreen).reset(transitionMapping);
    }
    break;
  case INSTRUCTIONS:
    currentScreen = GameScreen.START;
    screenMap.get(currentScreen).reset(transitionMapping);
    break;
  case CHOOSE_PLAYER:
    currentScreen = GameScreen.MAIN;
    screenMap.get(currentScreen).reset(transitionMapping);
    break;
  case MAIN:
    if (toSuggestedScreen == null) {
      //go to inventory
      currentScreen = GameScreen.INVENTORY;
      screenMap.get(currentScreen).reset(transitionMapping);
    } else if (toSuggestedScreen == GameScreen.GAME_RESULT) {
      currentScreen = GameScreen.GAME_RESULT;
      screenMap.get(currentScreen).reset(transitionMapping);
    }
    break;
  case INVENTORY:
    currentScreen = GameScreen.BATTLE;
    screenMap.get(currentScreen).reset(transitionMapping);
    break;
  case BATTLE:
    currentScreen = GameScreen.GAME_RESULT;
    screenMap.get(currentScreen).reset(transitionMapping);
    break;
  case GAME_RESULT:
    if (toSuggestedScreen == null) {
      currentScreen = GameScreen.START;
      screenMap.get(currentScreen).reset(transitionMapping);
    } else if (toSuggestedScreen == GameScreen.HIGH_SCORE) {
      currentScreen = GameScreen.HIGH_SCORE;
      if (transitionMapping == null) {
        transitionMapping = new HashMap(); 
      }
      transitionMapping.put(ScreenChangeDelegate.KEY_PREVIOUS_SCREEN, GameScreen.GAME_RESULT);
      screenMap.get(currentScreen).reset(transitionMapping);
    }
    break;
  case HIGH_SCORE:
    currentScreen = GameScreen.START;
    screenMap.get(currentScreen).reset(transitionMapping);
    break;
  case CREDITS:
    currentScreen = GameScreen.START;
    screenMap.get(currentScreen).reset(transitionMapping);
    break;
  }
}

private boolean isNewHighScore(int score) {
  return score > highScoresMap.firstKey();
}

private void updateHighScoresMap(int score, String name) {
  if (!isNewHighScore(score)) return;
  List<String> names = highScoresMap.get(score);
  if (names == null) {
    names = new ArrayList();
    highScoresMap.put(score, names);
  }
  names.add(name);

  int lowestScore = highScoresMap.firstKey();
  List<String> lowScoreNames = highScoresMap.get(lowestScore);
  lowScoreNames.remove(0);
  if (lowScoreNames.isEmpty()) {
    highScoresMap.remove(lowestScore);
  }

  writeHighScoresToFile();
}

private JSONArray createAndSaveNewHighScores() {
  JSONArray emptyScoresJsonArray = new JSONArray();
  for (int i=0; i < 10; i++) {
    JSONObject highScoreJson = new JSONObject();
    highScoreJson.put("score", 0);
    highScoreJson.put("name", "Kachi");
    emptyScoresJsonArray.append(highScoreJson);
  }

  saveJSONArray(emptyScoresJsonArray, dataPath(HIGH_SCORE_DEST_FILE));
  return emptyScoresJsonArray;
}

private void writeHighScoresToFile() {
  JSONArray highScoresJsonArray = new JSONArray();
  for (Integer score : highScoresMap.keySet()) {
    List<String> names = highScoresMap.get(score);
    for (String name : names) {
      JSONObject highScoreJson = new JSONObject();
      highScoreJson.put("score", score);
      highScoreJson.put("name", name);
      highScoresJsonArray.append(highScoreJson);
    }
  }
  saveJSONArray(highScoresJsonArray, dataPath(HIGH_SCORE_DEST_FILE));
}

private List<HighScore> generateHighScoreList() {
  List<HighScore> highScores = new ArrayList();

  for (Integer score : highScoresMap.keySet()) {
    List<String> names = highScoresMap.get(score);
    for (int i=names.size() - 1; i >= 0; i--) {
      String name = names.get(i);
      highScores.add(0, new HighScore(score, name));
    }
  }

  return highScores;
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