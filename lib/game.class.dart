import 'player.class.dart';

class Game {
  List players = [];
  List games = [];
  List currGame = [];
  num gamesPlayed = 0;

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

  Game(playerNames, handicaps) {
    this.players.add(new Player(playerNames[0], handicaps[0]));
    this.players.add(new Player(playerNames[1], handicaps[1]));
    players[0].active = true;
  }
}
