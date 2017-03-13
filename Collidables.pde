interface Collidable {
  void updateForDraw();
  boolean didCollide(BaseBobSled player);
}

interface Collectable extends Collidable {
 
  boolean didCollect(BaseBobSled player);
}