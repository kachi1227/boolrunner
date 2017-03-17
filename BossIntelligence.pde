import java.util.Arrays;
interface WorldAwarenessDelegate {
  boolean isProjectileWithinDistance(float distance);
  boolean areProjectilesAbove();
  float getPlayerHealth();
}

interface BossStatusDelegate {
  boolean isJumping();
  float getHealth();
}


/*
AI Rules
 When to Jump:
 If it detects that a projectile is within a certain distance, it should jump. - DONE
 If it detects that player jumps, it should make a random decision of whether or not it wants to jump after .5 second delay (to seem like its following)
 If about to shoot, AI can decide whether it wants to stay still, shoot and start jumping or jump and start shooting...
 
 When to Shoot:
 Shoot and should wait a while...Should shoot in random spurts then wait. Spurts of 3, 5, 7
 
 
 */
enum BossAction {
  NOTHING(0), JUMP(1), SHOOT(2), SHOOT_THREE(4), SHOOT_FIVE(8), SHOOT_SEVEN(16); 

  int flagValue;

  private BossAction(int value) {
    flagValue = value;
  }

  public int getFlag() {
    return flagValue;
  }
}

class PendingBossAction {
  long millisInFuture; 
  int actionFlag;
  PendingBossAction(long futureMillis, int flag) {
    millisInFuture = futureMillis;
    actionFlag = flag;
  }
}
class BossIntelligence {

  BossStatusDelegate statusDelegate;
  WorldAwarenessDelegate worldDelegate;

  List<PendingBossAction> pendingActions;
  BossIntelligence(BossStatusDelegate bsDelegate, WorldAwarenessDelegate waDelegate) {
    statusDelegate = bsDelegate;
    worldDelegate = waDelegate;
    pendingActions = new ArrayList();
  }

  double internalTimer;

  int getActionsToPerform() {
    int actionsToDo = BossAction.NOTHING.getFlag();
    if (pendingActions.size() > 0) {
      for (int i=pendingActions.size()-1; i >=0; i--) {
        PendingBossAction action = pendingActions.get(i);
        if (millis() > action.millisInFuture) {
          actionsToDo |= action.actionFlag;
          pendingActions.remove(i);
        }
      }
    }
    if (actionsToDo == 0) {
      if (worldDelegate.isProjectileWithinDistance(20)) {
        actionsToDo = BossAction.JUMP.getFlag();
      }
    }
    return actionsToDo;
  }

  void processPlayerJump() {
    int potentialActions[] = {BossAction.JUMP.getFlag(), BossAction.NOTHING.getFlag(), BossAction.NOTHING.getFlag(), 
      BossAction.JUMP.getFlag()|BossAction.SHOOT_FIVE.getFlag(), BossAction.JUMP.getFlag()|BossAction.SHOOT_THREE.getFlag(), 
      BossAction.NOTHING.getFlag(), BossAction.JUMP.getFlag(), BossAction.SHOOT_FIVE.getFlag(), BossAction.JUMP.getFlag(), 
      BossAction.JUMP.getFlag()|(worldDelegate.getPlayerHealth() < 40 ? BossAction.SHOOT_FIVE.getFlag() : BossAction.SHOOT_SEVEN.getFlag())};
    int chosenAction = potentialActions[int(random(potentialActions.length))];
    if ((chosenAction & BossAction.NOTHING.getFlag()) == 0) {
      if ((chosenAction & BossAction.JUMP.getFlag()) > 0) {
        pendingActions.add(new PendingBossAction(millis() + 250, chosenAction));
      }
      if ((chosenAction & ~BossAction.JUMP.getFlag()) > 0) {
        List<Integer> shootActions = breakdownMultipleShots(chosenAction);
        for (int i=0; i < shootActions.size(); i++) {
          pendingActions.add(new PendingBossAction(millis() + 250 + (i * 150), shootActions.get(i)));
        }
      }
    }
  }

  private List<Integer> breakdownMultipleShots(int flag) {
    List<Integer> totalSingleShots = null;
    int shotCount = 0;
    if ((flag & BossAction.SHOOT_THREE.getFlag()) > 0) {
      shotCount = 3;
    } else if ((flag & BossAction.SHOOT_FIVE.getFlag()) > 0) {
      shotCount = 5;
    } else if ((flag & BossAction.SHOOT_SEVEN.getFlag()) > 0) {
      shotCount = 7;
    }
    if (shotCount > 0) {
      totalSingleShots = new ArrayList();
      for (int i=0; i < shotCount; i++) {
        totalSingleShots.add(BossAction.SHOOT.getFlag());
      }
    }
    return totalSingleShots;
  }
}