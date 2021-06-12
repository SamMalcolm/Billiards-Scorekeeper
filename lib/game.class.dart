import 'player.class.dart';
import 'components.dart';

class Game {
  List players = [];
  List frames = [];
  List currFrame = [];
  num framesPlayed = 0;
  num pointsRemaining = 147;

// BALLS
  num redsRemaining = 15;
  num yellowsRemaining = 1;
  num greensRemaining = 1;
  num brownsRemaining = 1;
  num bluesRemaining = 1;
  num pinksRemaining = 1;
  num blacksRemaining = 1;
  bool freeBall = false;
  num minFoul = 4;

  void calculatePointsRemaining() {
    pointsRemaining = (8 * redsRemaining) +
        (2 * yellowsRemaining) +
        (3 * greensRemaining) +
        (4 * brownsRemaining) +
        (5 * bluesRemaining) +
        (6 * pinksRemaining) +
        (7 * blacksRemaining);
    if (currFrame.length > 0) {
      if (currFrame[currFrame.length - 1] == "R") {
        pointsRemaining += 7;
      }
    }
    num inactivePointsRemaining = pointsRemaining;
    if (currFrame.length != 0) {
      if (currFrame.last.contains("R")) {
        inactivePointsRemaining -= 7;
      }
    }

    Player p = getInactivePlayer();
    Player a = getActivePlayer();

    a.updateMaxScore(pointsRemaining);
    p.updateMaxScore(inactivePointsRemaining);
    a.updateScoreLine(pointsRemaining, p.score, minFoul, p.maxScore);
    p.updateScoreLine(inactivePointsRemaining, a.score, minFoul, a.maxScore);
  }

  bool lastActionRed() {
    if (currFrame.length == 0) {
      return false;
    } else {
      if (currFrame.last.contains("R")) {
        return true;
      } else {
        for (int i = currFrame.length - 1; i >= 0; i--) {
          if (currFrame[i].contains("ir") || currFrame[i].contains("dr")) {
            continue;
          } else {
            if (currFrame[i].contains("R")) {
              return true;
            } else {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  void incrementReds() {
    redsRemaining++;
    currFrame.add('ir');
    calculatePointsRemaining();
  }

  void decrementReds() {
    if (redsRemaining > 0) {
      redsRemaining--;
      currFrame.add('dr');
      calculatePointsRemaining();
    }
  }

  bool validateFinalColours(c) {
    if (pointsRemaining > 27) {
      return true;
    } else {
      if (pointsRemaining == 27 && c == "Y") {
        return true;
      } else if (pointsRemaining == 25 && c == "G") {
        return true;
      } else if (pointsRemaining == 22 && c == "br") {
        return true;
      } else if (pointsRemaining == 18 && c == "bl") {
        return true;
      } else if (pointsRemaining == 13 && c == "P") {
        return true;
      } else if (pointsRemaining == 7 && c == "B") {
        return true;
      } else {
        return false;
      }
    }
  }

  void foul(value) {
    currFrame.add('F$value');

    Player p = getInactivePlayer();
    p.score += value;
    p.foulPointsRecieved += value;

    Player a = getActivePlayer();
    a.foulPointsGiven += value;

    calculatePointsRemaining();
  }

  Player getActivePlayer() {
    List pl = players.where((p) => p.active).toList();
    Player p = pl[0];
    return p;
  }

  Player getInactivePlayer() {
    List pl = players.where((p) => !p.active).toList();
    Player p = pl[0];
    return p;
  }

  void passTurn() {
    for (int i = 0; i < players.length; i++) {
      players[i].currBreak = 0;
      if (players[i].active) {
        players[i].active = false;
      } else {
        players[i].active = true;
      }
    }
    currFrame.add('PT');
    calculatePointsRemaining();
  }

  void endGame() {
    framesPlayed++;
    currFrame.add("END");
    frames.add(currFrame);
    currFrame = [];

    if (players[0].score > players[1].score) {
      players[0].framesWon++;
    } else {
      players[1].framesWon++;
    }

    for (int i = 0; i < players.length; i++) {
      players[i].score = players[i].handicap;
      players[i].currBreak = 0;
      players[i].snookersRequired = 0;
      players[i].maxScore = 147;
      players[i].snookersReqdScoreline = 74;
    }

    redsRemaining = 15;
    yellowsRemaining = 1;
    greensRemaining = 1;
    brownsRemaining = 1;
    bluesRemaining = 1;
    pinksRemaining = 1;
    blacksRemaining = 1;
    minFoul = 4;
    calculatePointsRemaining();
  }

  void pot(colour, fb) {
    Player ap = getActivePlayer();
    switch (colour) {
      case "R":
        ap.score++;
        ap.currBreak++;
        if (!fb) {
          redsRemaining--;
        }
        break;
      case "Y":
        ap.score += 2;
        ap.currBreak += 2;
        if (redsRemaining == 0 &&
            !fb &&
            (currFrame[currFrame.length - 1] != "R" &&
                currFrame[currFrame.length - 1] != "R*")) {
          yellowsRemaining--;
        }
        break;
      case "G":
        ap.score += 3;
        ap.currBreak += 3;
        if (redsRemaining == 0 &&
            !fb &&
            (currFrame[currFrame.length - 1] != "R" &&
                currFrame[currFrame.length - 1] != "R*")) {
          greensRemaining--;
        }
        break;
      case "br":
        ap.score += 4;
        ap.currBreak += 4;
        if (redsRemaining == 0 &&
            !fb &&
            (currFrame[currFrame.length - 1] != "R" &&
                currFrame[currFrame.length - 1] != "R*")) {
          brownsRemaining--;
        }
        break;
      case "bl":
        ap.score += 5;
        ap.currBreak += 5;
        if (redsRemaining == 0 &&
            !fb &&
            (currFrame[currFrame.length - 1] != "R" &&
                currFrame[currFrame.length - 1] != "R*")) {
          bluesRemaining--;
        }
        break;
      case "P":
        ap.score += 6;
        ap.currBreak += 6;
        if (redsRemaining == 0 &&
            !fb &&
            (currFrame[currFrame.length - 1] != "R" &&
                currFrame[currFrame.length - 1] != "R*")) {
          pinksRemaining--;
        }
        break;
      case "B":
        ap.score += 7;
        ap.currBreak += 7;
        if (redsRemaining == 0 &&
            !fb &&
            (currFrame[currFrame.length - 1] != "R" &&
                currFrame[currFrame.length - 1] != "R*")) {
          blacksRemaining--;
        }
        break;
    }
    if (!fb) {
      currFrame.add(colour);
    } else {
      currFrame.add('$colour*');
    }

    if (brownsRemaining == 0) {
      minFoul = 5;
    }
    if (bluesRemaining == 0) {
      minFoul = 6;
    }
    if (pinksRemaining == 0) {
      minFoul = 7;
    }

    if (ap.currBreak > ap.highestBreak) {
      ap.highestBreak = ap.currBreak;
    }

    calculatePointsRemaining();

    if (blacksRemaining == 0) {
      if (players[1].score != players[0].score) {
        endGame();
      } else {
        blacksRemaining++;
      }
    }
  }

  void undo() {
    Player ip = getInactivePlayer();
    Player ap = getActivePlayer();

    if (currFrame.length > 0) {
      String lastAction = currFrame.removeLast();
      if (lastAction == "dr" || lastAction == "ir") {
        if (lastAction == "dr") {
          redsRemaining++;
        } else {
          redsRemaining--;
        }
      }
      for (int i = 0; i < balls.length; i++) {
        if (lastAction.contains(balls[i]['code']) &&
            !lastAction.contains("T")) {
          ap.score -= balls[i]['value'];
          if (ap.currBreak == ap.highestBreak) {
            ap.highestBreak -= balls[i]['value'];
          }
          if (ap.currBreak > 0) {
            ap.currBreak -= balls[i]['value'];
          }
          if (!lastAction.contains('*')) {
            if (balls[i]['code'].contains("R")) {
              redsRemaining++;
            } else if (redsRemaining == 0) {
              if (balls[i]['code'].contains("Y")) {
                yellowsRemaining = 1;
              }
              if (balls[i]['code'].contains("G")) {
                greensRemaining = 1;
              }
              if (balls[i]['code'].contains("br")) {
                brownsRemaining = 1;
              }
              if (balls[i]['code'].contains("bl")) {
                bluesRemaining = 1;
              }
              if (balls[i]['code'].contains("P")) {
                pinksRemaining = 1;
              }
              if (balls[i]['code'].contains("B")) {
                blacksRemaining = 1;
              }
            }
          }
          calculatePointsRemaining();
          return;
        }
      }

      switch (lastAction) {
        case "PT":
          passTurn();
          currFrame.removeLast();
          break;
        case "F4":
          ip.score -= 4;
          ip.foulPointsRecieved -= 4;
          ap.foulPointsGiven -= 4;
          break;
        case "F5":
          ip.score -= 5;
          ip.foulPointsRecieved -= 5;
          ap.foulPointsGiven -= 5;
          break;
        case "F6":
          ip.score -= 6;
          ip.foulPointsRecieved -= 6;
          ap.foulPointsGiven -= 6;
          break;
        case "F7":
          ip.score -= 7;
          ip.foulPointsRecieved -= 7;
          ap.foulPointsGiven -= 7;
          break;
      }
      calculatePointsRemaining();
    }
  }

  Game(playerNames, handicaps) {
    this.players.add(new Player(playerNames[0], handicaps[0]));
    this.players.add(new Player(playerNames[1], handicaps[1]));
    this.redsRemaining = 15;
    players[0].active = true;
  }
}
