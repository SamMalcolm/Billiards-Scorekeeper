import 'player.class.dart';

class Game {
  List players = [];
  List games = [];
  List currGame = [];
  num gamesPlayed = 0;
  bool timed = false;
  num minutes = 0;
  num targetScore = 0;
  bool handicappedByTiers = false;
  bool handicapped = false;
  bool baulkLineWarningDue = false;
  bool cannonWarningDue = false;
  bool hazardWarningDue = false;
  bool opponentPotted = false;
  List<num> baulkLineWarningsIssued = [];
  String winCondition = 'score';
  bool locked = false;
  bool baulkLineCrossingRuleApplies = true;

  void foul() {
    currGame.add('F2');

    Player p = getInactivePlayer();
    p.rawScore += 2;
    p.foulPointsRecieved += 2;

    Player a = getActivePlayer();
    a.foulPointsGiven += 2;

    passTurn();
  }

  void miss() {
    currGame.add('M2');

    Player p = getInactivePlayer();
    p.rawScore += 2;
    p.foulPointsRecieved += 2;

    Player a = getActivePlayer();
    a.foulPointsGiven += 2;

    passTurn();
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

  void stroke(lh2, wh2, c, lh3, wh3) {
    List<String> stroke = [];
    Player p = this.getActivePlayer();

    if (c && (!lh2 && !wh2 && !lh3 && !wh3)) {
      p.consecutiveCannons++;
    } else {
      p.consecutiveCannons = 0;
    }

    if (!c && (lh2 || wh2 || lh3 || wh3)) {
      p.consecutiveHazards++;
    }

    if (c) {
      p.consecutiveHazards = 0;
    }

    if (lh2) {
      p.rawScore += 2;
      p.currBreak += 2;
      stroke.add("LH2");
    }
    if (wh2) {
      p.rawScore += 2;
      p.currBreak += 2;
      opponentPotted = true;
      stroke.add("WH2");
    }
    if (c) {
      p.rawScore += 2;
      p.currBreak += 2;
      stroke.add("C");
    }
    if (lh3) {
      p.rawScore += 3;
      p.currBreak += 3;
      stroke.add("LH3");
    }
    if (wh3) {
      p.rawScore += 3;
      p.currBreak += 3;
      stroke.add("WH3");
    }

    if (p.currBreak > p.highestBreak) {
      p.highestBreak = p.currBreak;
    }

    if (this.targetScore > 0 && p.score >= this.targetScore) {
      this.locked = true;
    }

    if (p.currBreak >= 80 && this.baulkLineCrossingRuleApplies) {
      if (baulkLineWarningsIssued.length > 0) {
        num lastWarningGiven = baulkLineWarningsIssued.removeLast();
        print("LAST WARNING");
        print(lastWarningGiven);
        if ((p.currBreak - lastWarningGiven) >= 50) {
          this.baulkLineWarningDue = true;
        }
        baulkLineWarningsIssued.add(lastWarningGiven);
      } else {
        this.baulkLineWarningDue = true;
      }
    }

    if (p.consecutiveHazards == 10) {
      this.hazardWarningDue = true;
    }

    if (p.consecutiveCannons == 70) {
      this.cannonWarningDue = true;
    }

    currGame.add(stroke);
  }

  void baulkLineWarningGiven() {
    Player ap = this.getActivePlayer();

    this.baulkLineWarningsIssued.add(ap.currBreak);
    this.baulkLineWarningDue = false;
  }

  void passTurn() {
    opponentPotted = false;

    Player ap = this.getActivePlayer();
    ap.consecutiveCannons = 0;
    ap.consecutiveHazards = 0;
    this.baulkLineWarningsIssued = [];
    ap.currBreak = 0;
    for (int i = 0; i < players.length; i++) {
      players[i].currBreak = 0;
      if (players[i].active) {
        players[i].active = false;
      } else {
        players[i].active = true;
      }
    }
    currGame.add('PT');
  }

  void endGame() {
    baulkLineWarningDue = false;
    cannonWarningDue = false;
    hazardWarningDue = false;
    opponentPotted = false;
    baulkLineWarningsIssued = [];
    gamesPlayed++;
    currGame.add("END");
    games.add(currGame);
    currGame = [];

    if (players[0].score > players[1].score) {
      players[0].gamesWon++;
    } else {
      players[1].gamesWon++;
    }

    for (int i = 0; i < players.length; i++) {
      players[i].rawScore = players[i].handicap;
      players[i].currBreak = 0;
    }
  }

  void undo() {
    Player ip = getInactivePlayer();
    Player ap = getActivePlayer();

    if (currGame.length > 0) {
      dynamic lastStroke = currGame.removeLast();

      print("LAST ACTION");

      print(lastStroke);

      if (lastStroke.runtimeType == "String") {
        if (lastStroke == "M2" || lastStroke == "F2") {
          ap.rawScore -= 2;
        } else if (lastStroke == "PT") {
          passTurn();
        }
      } else {
        if (lastStroke.contains("C") && lastStroke.length == 1) {
          ap.consecutiveCannons--;
          ap.rawScore -= 2;
        } else if ((lastStroke.contains("WH2") ||
                lastStroke.contains("LH2") ||
                lastStroke.contains("WH3") ||
                lastStroke.contains("LH3")) &&
            lastStroke.contains("C") == false) {
          ap.consecutiveHazards--;
        }
        if (lastStroke.contains("LH2")) {
          ap.rawScore -= 2;
        }
        if (lastStroke.contains("WH2")) {
          ap.rawScore -= 2;
          this.opponentPotted = false;
        }
        if (lastStroke.contains("WH3")) {
          ap.rawScore -= 3;
        }
        if (lastStroke.contains("LH3")) {
          ap.rawScore -= 3;
        }
      }
    }
  }

  Game(playerNames, handicaps, tiers, handicappedByTiers, timed, minutes,
      targetScore) {
    this.handicappedByTiers = handicappedByTiers;
    print(handicaps);
    if (this.handicappedByTiers) {
      this.handicapped = true;
    }

    if (handicaps.length > 0 && (handicaps[0] != 0 && handicaps[1] != 0)) {
      this.handicapped = true;
    }

    print(this.handicapped);
    num multiplier = 1.0;
    bool mpForP1 = false;
    if (tiers[0] != 0 && tiers[1] != 0 && handicappedByTiers) {
      if (tiers[0] < tiers[1]) {
        multiplier = ((tiers[1] - tiers[0]) * 0.5) + 1.0;
      } else {
        mpForP1 = true;
        multiplier = ((tiers[0] - tiers[1]) * 0.5) + 1.0;
      }
    }
    this.players.add(new Player(
        playerNames[0], handicaps[0], tiers[0], (mpForP1) ? multiplier : 1.0));
    this.players.add(new Player(
        playerNames[1], handicaps[1], tiers[1], (!mpForP1) ? multiplier : 1.0));
    this.timed = timed;
    this.targetScore = targetScore;
    this.minutes = minutes;
    players[0].active = true;
  }
}
