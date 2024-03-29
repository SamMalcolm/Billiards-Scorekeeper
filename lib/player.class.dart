class Player {
  // NAME
  String name;

  // SCORING METRICS
  num handicap = 0;

  num get score {
    return ((rawScore * multiplier) + handicap);
  }

  num gamesWon = 0;
  num tier = 0;

  // FOUL
  num foulPointsGiven = 0;
  num foulPointsRecieved = 0;

  // AT TABLE
  bool active = false;

  // BREAK
  num currBreak = 0;
  num highestBreak = 0;

  // LIMITS

  num consecutiveCannons = 0;
  num consecutiveHazards = 0;

  num rawScore = 0;
  num multiplier = 1;

  Player(this.name, this.handicap, this.tier, this.multiplier) {
    this.gamesWon = 0;
  }
}
