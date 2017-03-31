class CreditsScreen extends BaseGameScreen {

  private final static float BASE_MUSIC_GAIN = -20;

  AudioPlayer backgroundMusicPlayer;

  float offset;
  float alpha;

  String allCredits;
  PImage kachImage;

  CreditsScreen(ScreenChangeDelegate delegate) {
    super(delegate);
    loadCredits();
    loadCreditImage();
    loadMusicFiles();
  }

  private void loadCredits() {
    String[] creditLines = loadStrings("credits.txt");
    allCredits = "";
    for (String credit : creditLines) {
      allCredits += (credit + "\n");
    }
  }
  
  private void loadCreditImage() {
    kachImage = loadImage("young_tukach.png"); 
  }

  private void loadMusicFiles() {
    Minim minim = new Minim(BoolRunnings.this);
    backgroundMusicPlayer = minim.loadFile("ControllaDrake.mp3");
  }

  void reset(Map<String, Object> gameStateValues) {
    super.reset(gameStateValues);
    if (gameStateValues == null) return;
    offset = 0;
    alpha = 255;
    backgroundMusicPlayer.setGain(BASE_MUSIC_GAIN);
    backgroundMusicPlayer.cue(0);
    backgroundMusicPlayer.play();
  }

  void drawScreen() {
    fill(0);
    background(0);
    createCredits();
  }

  private void createCredits() {
    textAlign(CENTER, TOP);
    textSize(24);
    fill(255, alpha);

    text(allCredits, 0, height + 20 - offset, width, 1830);

    textSize(36);
    text("Kachi Nwaobasi", width/2, height + 20 - offset + 1830);
    tint(255, alpha);
    image(kachImage, width/2 - 150, height + 20 - offset + 1870, 300, 300);
    if (offset <= 2240) { //hard coded value..shouldn't be. Will hardcode for sake of time..
      offset += 1;
      println(offset);
    } else {
      alpha -= 1.5;
      backgroundMusicPlayer.setGain(BASE_MUSIC_GAIN - (20 - (20 * (alpha/255))));
      if (alpha <= 0) {
        returnToStartScreen();
      }
    }
  }

  private void returnToStartScreen() {
    performCleanup();
    delegate.performScreenChange(null, null);
  }

  private void performCleanup() {
    backgroundMusicPlayer.pause();
  }

  boolean handleKeyPressed() {
    boolean handled = super.handleKeyPressed();
    if (handled) performCleanup();
    return handled;
  }
}