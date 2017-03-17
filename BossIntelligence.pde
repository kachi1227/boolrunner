import java.util.Arrays;
interface WorldAwarenessDelegate {
  boolean isProjectileWithinStrikingDistance(float distance);
  PlayerProjectileData getPlayerProjectileData();
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
 If it detects that player jumps, it should make a random decision of whether or not it wants to jump after .5 second delay (to seem like its following) DONE
 If about to shoot, AI can decide whether it wants to stay still, shoot and start jumping or jump and start shooting... DONE
 
 When to Shoot:
 Shoot and should wait a while...Should shoot in random spurts then wait. Spurts of 1, 3, 5, 6 DONE
 
 
 */
enum BossAction {
  NOTHING(0), JUMP(1), SHOOT(2), SHOOT_THREE(4), SHOOT_FIVE(8), SHOOT_SIX(16); 

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

class PlayerProjectileData {
  int totalCount;
  int aboveCount;
  float furthest = Float.MIN_VALUE;
  float closest = Float.MAX_VALUE;
}
class BossIntelligence {
  private static final int MILLIS_BETWEEN_UNPROVOKED_ATTACKS = 3000;
  BossStatusDelegate statusDelegate;
  WorldAwarenessDelegate worldDelegate;

  List<PendingBossAction> pendingActions;
  BossIntelligence(BossStatusDelegate bsDelegate, WorldAwarenessDelegate waDelegate) {
    statusDelegate = bsDelegate;
    worldDelegate = waDelegate;
    pendingActions = new ArrayList();
  }

  long lastUnprovokedShotTime;

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
      if (worldDelegate.isProjectileWithinStrikingDistance(20)) {
        actionsToDo = BossAction.JUMP.getFlag();
      } else if (millis() - lastUnprovokedShotTime > BossIntelligence.MILLIS_BETWEEN_UNPROVOKED_ATTACKS) {
        constructUnprovokedAttack();
      }
    }
    return actionsToDo;
  }

  void constructUnprovokedAttack() {
    int potentialAuxillaryMove[] = {BossAction.JUMP.getFlag(), BossAction.NOTHING.getFlag(), BossAction.NOTHING.getFlag(), 
      BossAction.JUMP.getFlag(), BossAction.JUMP.getFlag(), BossAction.NOTHING.getFlag()};
    int potentialShotMove[] = {BossAction.SHOOT_FIVE.getFlag(), BossAction.SHOOT_THREE.getFlag(), BossAction.SHOOT_FIVE.getFlag(), 
      (worldDelegate.getPlayerHealth() < 40 ? BossAction.SHOOT_FIVE.getFlag() : BossAction.SHOOT_SIX.getFlag()), 
      BossAction.SHOOT.getFlag(), BossAction.SHOOT_SIX.getFlag(), BossAction.SHOOT_THREE.getFlag()};
      
    PlayerProjectileData data = worldDelegate.getPlayerProjectileData();
    //if we've randomly decided to jump, only do so if there is nothing above us OR if there are more things aimed at us than are above us
    boolean allowedToJump = (data.aboveCount == 0 || data.aboveCount < data.totalCount - data.aboveCount);
    int firstMove = allowedToJump ? potentialAuxillaryMove[int(random(potentialAuxillaryMove.length))] : BossAction.NOTHING.getFlag();
    pendingActions.add(new PendingBossAction(millis(), firstMove));
    int shotMove = potentialShotMove[int(random(potentialShotMove.length))];
    List<Integer> shootActions = breakdownMultipleShots(shotMove);
    for (int i=0; i < shootActions.size(); i++) {
      println("Shots set up");
      pendingActions.add(new PendingBossAction(millis() + (i * 150), shootActions.get(i)));
    }
    if (allowedToJump && (firstMove & BossAction.JUMP.getFlag()) == 0) {
      int potentialJumpMoment = int(random(shootActions.size()));
      int lastMove = potentialAuxillaryMove[int(random(potentialAuxillaryMove.length))];
      pendingActions.add(new PendingBossAction(millis() + (potentialJumpMoment * 150), lastMove));
    }
    lastUnprovokedShotTime = pendingActions.get(pendingActions.size() - 2).millisInFuture; //this gets the time of last actual shot
  }

  void processPlayerJump() {
    int potentialActions[] = {BossAction.JUMP.getFlag(), BossAction.NOTHING.getFlag(), BossAction.NOTHING.getFlag(), 
      BossAction.JUMP.getFlag()|BossAction.SHOOT_FIVE.getFlag(), BossAction.JUMP.getFlag()|BossAction.SHOOT_THREE.getFlag(), 
      BossAction.NOTHING.getFlag(), BossAction.JUMP.getFlag(), BossAction.SHOOT_FIVE.getFlag(), BossAction.JUMP.getFlag(), 
      BossAction.JUMP.getFlag()|(worldDelegate.getPlayerHealth() < 40 ? BossAction.SHOOT_FIVE.getFlag() : BossAction.SHOOT_SIX.getFlag())};

    int chosenAction = potentialActions[int(random(potentialActions.length))];
    if ((chosenAction & BossAction.NOTHING.getFlag()) == 0) {
      PlayerProjectileData data = worldDelegate.getPlayerProjectileData();
      //if we've randomly decided to jump, only do so if there is nothing above us OR if there are more things aimed at us than are above us
      if ((chosenAction & BossAction.JUMP.getFlag()) > 0 && (data.aboveCount == 0 || data.aboveCount < data.totalCount - data.aboveCount/* || data.closest > 600*/)) {
        pendingActions.add(new PendingBossAction(millis() + 250, chosenAction));
      }
      if ((chosenAction & ~BossAction.JUMP.getFlag()) > 0) {
        println("Lets get to shooting");
        List<Integer> shootActions = breakdownMultipleShots(chosenAction);
        for (int i=0; i < shootActions.size(); i++) {
          println("Shots set up");
          pendingActions.add(new PendingBossAction(millis() + 250 + (i * 150), shootActions.get(i)));
        }
      }
    }
  }

  private List<Integer> breakdownMultipleShots(int flag) {
    List<Integer> totalSingleShots = null;
    int shotCount = 0;
    if ((flag & BossAction.SHOOT.getFlag()) > 0) {
      shotCount = 1;
    } else if ((flag & BossAction.SHOOT_THREE.getFlag()) > 0) {
      shotCount = 3;
    } else if ((flag & BossAction.SHOOT_FIVE.getFlag()) > 0) {
      shotCount = 5;
    } else if ((flag & BossAction.SHOOT_SIX.getFlag()) > 0) {
      shotCount = 6;
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