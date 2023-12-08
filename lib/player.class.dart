class Player {
  // NAME
  String name;

  // SCORING METRICS
  num handicap = 0;
  num score = 0;
  num gamesWon = 0;
  num vbsaTier = 0;

  // FOUL
  num foulPointsGiven = 0;
  num foulPointsRecieved = 0;

  // AT TABLE
  bool active = false;

  // BREAK
  num currBreak = 0;
  num highestBreak = 0;

  // LIMITS

  num connsecutiveCannons = 0;
  num connsecutiveHazards = 0;

  Player(this.name, this.handicap) {
    this.score = 0;
    this.gamesWon = 0;
    score += handicap;
  }
}
