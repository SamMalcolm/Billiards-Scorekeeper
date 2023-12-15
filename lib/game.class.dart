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

  String winCondition = 'score';

  bool baulkLineCrossingRuleApplies = true;

  void foul(value) {
    currGame.add('F2');

    Player p = getInactivePlayer();
    p.score += 2;
    p.foulPointsRecieved += 2;

    Player a = getActivePlayer();
    a.foulPointsGiven += 2;
  }

  void miss() {
    currGame.add('M2');

    Player p = getInactivePlayer();
    p.score += 2;
    p.foulPointsRecieved += 2;

    Player a = getActivePlayer();
    a.foulPointsGiven += 2;
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
      p.connsecutiveCannons++;
    } else {
      p.connsecutiveCannons = 0;
    }

    if (!c && (lh2 || wh2 || lh3 || wh3)) {
      p.connsecutiveHazards++;
    }

    if (c) {
      p.connsecutiveHazards = 0;
    }

    if (lh2) {
      p.rawScore += 2;
      p.currBreak += 2;
      stroke.add("LH2");
    }
    if (wh2) {
      p.rawScore += 2;
      p.currBreak += 2;
      stroke.add("LH2");
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
    if (this.handicappedByTiers) {
      p.score = p.multiplier * p.rawScore;
    } else {
      p.score = p.rawScore + p.handicap;
    }
    currGame.add(stroke);
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
    currGame.add('PT');
  }

  void endGame() {
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
      players[i].score = players[i].handicap;
      players[i].currBreak = 0;
    }
  }

  void undo() {
    Player ip = getInactivePlayer();
    Player ap = getActivePlayer();

    if (currGame.length > 0) {
      String lastAction = currGame.removeLast();
      switch (lastAction) {
        case "PT":
          passTurn();
          currGame.removeLast();
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
    }
  }

  Game(playerNames, handicaps, tiers, handicappedByTiers, timed, minutes,
      targetScore) {
    this.handicappedByTiers = handicappedByTiers;
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
