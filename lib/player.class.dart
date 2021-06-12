import 'package:flutter/material.dart';

class Player {
  // NAME
  String name;

  // SCORING METRICS
  num handicap = 0;
  num score = 0;
  num framesWon = 0;
  num snookersRequired = 0;

  // FOUL
  num foulPointsGiven = 0;
  num foulPointsRecieved = 0;

  // AT TABLE
  bool active = false;

  // BREAK
  num currBreak = 0;
  num highestBreak = 0;

  // SCORELINE DATA
  num maxScore = 147;
  double scoreFractionOfMax = 0;
  num snookersReqdScoreline = 74;
  double snookersReqdFractionOfMax = 74 / 147;
  double maxScoreFraction = 1;

  Color winningScorelineColor = Color(0xFFC3A164);

  void updateMaxScore(pointsRemaining) {
    maxScore = pointsRemaining + score;
  }

  void updateScoreLine(
      pointsRemaining, opponentsScore, minFoul, opponentMaxScore) {
    winningScorelineColor = Color(0xFFC3A164);
    maxScore = score + pointsRemaining;
    num max = (maxScore >= opponentMaxScore) ? maxScore : opponentMaxScore;
    maxScoreFraction = (maxScore / max);
    scoreFractionOfMax = (score / max);
    if (scoreFractionOfMax < 0) {
      scoreFractionOfMax = 0;
    }
    if (maxScore < opponentsScore) {
      double sr = (opponentsScore - maxScore) / minFoul;
      snookersRequired = sr.ceil();
      snookersReqdFractionOfMax = 0;
    } else {
      snookersRequired = 0;

      int scoringPoints = 0;
      snookersReqdFractionOfMax = 0;
      int diff = (opponentsScore > score)
          ? (opponentsScore - score)
          : (score - opponentsScore);

      if (diff <= 7 && pointsRemaining == 7) {
        snookersReqdFractionOfMax = 1.0;
        snookersReqdScoreline = maxScore;
        winningScorelineColor = const Color(0xff0B0B0B);
      } else {
        while (scoringPoints <= pointsRemaining) {
          num pottentialScore = score;
          num pottentialPointsRemaining = pointsRemaining;
          pottentialScore += scoringPoints;
          pottentialPointsRemaining -= scoringPoints;
          if (opponentsScore + pottentialPointsRemaining < pottentialScore) {
            snookersReqdScoreline = pottentialScore;
            break;
          }
          if (pottentialPointsRemaining <= 27) {
            if (pottentialPointsRemaining == 27) {
              scoringPoints += 2;
              winningScorelineColor = const Color(0xffCEB636);
            } else if (pottentialPointsRemaining == 25) {
              scoringPoints += 3;
              winningScorelineColor = const Color(0xff397140);
            } else if (pottentialPointsRemaining == 22) {
              scoringPoints += 4;
              winningScorelineColor = const Color(0xff694A20);
            } else if (pottentialPointsRemaining == 18) {
              scoringPoints += 5;
              winningScorelineColor = const Color(0xff2F4EB4);
            } else if (pottentialPointsRemaining == 13) {
              scoringPoints += 6;
              winningScorelineColor = const Color(0xff9B3D9B);
            } else if (pottentialPointsRemaining == 7) {
              scoringPoints += 7;
              winningScorelineColor = const Color(0xff0B0B0B);
            } else {
              break;
            }
          } else {
            scoringPoints++;
          }

          if (pottentialPointsRemaining < 0) {
            break;
          }
        }
      }
      snookersReqdFractionOfMax = snookersReqdScoreline / max;

      if (snookersReqdScoreline > maxScore ||
          opponentsScore + pointsRemaining < score) {
        snookersReqdFractionOfMax = 0;
      }
    }
  }

  Player(this.name, this.handicap) {
    this.score = 0;
    this.framesWon = 0;
    score += handicap;
  }
}
