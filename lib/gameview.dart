import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game.class.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'components.dart';
import 'blurryDialog.dart';
import 'main.dart';
import 'timer.class.dart';

class GameView extends StatefulWidget {
  GameView(
      {Key? key,
      required this.playerNames,
      required this.playerHandicaps,
      required this.playerTiers,
      required this.handicap,
      required this.handicappedpWithTiers,
      required this.timed,
      required this.targetScore,
      required this.minutes})
      : super(key: key);

  final List playerNames;
  final List playerHandicaps;
  final List playerTiers;
  final bool handicap;
  final bool handicappedpWithTiers;
  final num targetScore;
  final bool timed;
  final int minutes;

  @override
  _GameView createState() => _GameView();
}

class _GameView extends State<GameView> {
  num? redsRemaining = 15;
  Game game =
      new Game(["default", "default2"], [0, 0], [0, 0], false, false, 0, 0);
  bool foulInput = false;
  bool fb = false;
  bool init = false;

  bool lh2 = false;
  bool wh2 = false;
  bool wh3 = false;
  bool c = false;
  bool lh3 = false;

  List scoringInput(context) {
    List<Widget> colChildren = [];
    if (!game.opponentPotted)
      colChildren.addAll([
        Text("Two Point Scores"),
        SizedBox(height: 10.00),
        Row(children: [
          bigButton(
              Text('Losing Hazard',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 22,
                    color: ((game.players[1].active))
                        ? Colors.white
                        : const Color(0xff9D2C2C),
                  )),
              (game.players[1].active)
                  ? [
                      Color.fromARGB(255, 225, 183, 14),
                      Color.fromARGB(255, 197, 156, 11),
                    ]
                  : [
                      Color.fromARGB(255, 250, 247, 222),
                      Color.fromARGB(255, 216, 214, 192),
                    ], () {
            setState(() => lh2 = !lh2);
          }, border: lh2, borderColour: Color.fromARGB(255, 152, 80, 80)),
          SizedBox(width: 10),
          bigButton(
              Text('Winning Hazard',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 22,
                    color: ((game.players[1].active))
                        ? Colors.white
                        : const Color(0xff9D2C2C),
                  )),
              (game.players[1].active)
                  ? [
                      Color.fromARGB(255, 225, 183, 14),
                      Color.fromARGB(255, 197, 156, 11),
                    ]
                  : [
                      Color.fromARGB(255, 250, 247, 222),
                      Color.fromARGB(255, 216, 214, 192),
                    ], () {
            setState(() => wh2 = !wh2);
          }, border: wh2, borderColour: Color.fromARGB(255, 152, 80, 80)),
        ]),
        SizedBox(height: 10.00),
        Row(children: [
          bigButton(
              Text('Cannon',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 22,
                    color: Colors.white,
                  )),
              [
                (game.players[0].active)
                    ? Color.fromARGB(255, 216, 214, 192)
                    : Color.fromARGB(255, 225, 183, 14),
                const Color(0xff9D2C2C),
              ], () {
            setState(() => c = !c);
          }, border: c),
        ]),
      ]);
    List output = [];
    colChildren.addAll([
      Divider(),
      Text("Three Point Scores"),
      SizedBox(height: 10.00),
      Row(children: [
        bigButton(
            Text('Losing Hazard',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 22,
                  color: Colors.white,
                )),
            [
              const Color(0xffC72D2D),
              const Color(0xff9D2C2C),
            ], () {
          setState(() => lh3 = !lh3);
        }, border: lh3),
        SizedBox(width: 10.00),
        bigButton(
            Text('Winning Hazard',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 22,
                  color: Colors.white,
                )),
            [
              const Color(0xffC72D2D),
              const Color(0xff9D2C2C),
            ], () {
          setState(() => wh3 = !wh3);
        }, border: wh3),
      ]),
      SizedBox(height: 10.00),
      Divider(),
      Row(children: [
        bigButton(
            Text('Submit Stroke',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 22,
                  color: Colors.white,
                )),
            [
              const Color(0xff4CA256),
              const Color(0xff397140),
            ], () {
          setState(() {
            game.stroke(lh2, wh2, c, lh3, wh3);
            lh2 = false;
            wh2 = false;
            c = false;
            lh3 = false;
            wh3 = false;

            if (game.hazardWarningDue)
              _showDialog(
                context,
                () {
                  setState(() {
                    print("RUNNING");
                    game.hazardWarningDue = false;
                  });
                },
                "Player is due for warning",
                "Please warn the player they are approaching the limit of 15 consecutive hazards by announcing 'TEN HAZARDS'",
              );
            if (game.cannonWarningDue)
              _showDialog(
                context,
                () {
                  setState(() {
                    print("RUNNING");
                    game.cannonWarningDue = false;
                  });
                },
                "Player is due for warning",
                "Please warn the player they are approaching the limit of 75 consecutive cannons by announcing 'SEVENTY CANONS'",
              );
            if (game.baulkLineWarningDue)
              _showDialog(
                context,
                () {
                  setState(() {
                    print("RUNNING");
                    game.baulkLineWarningGiven();
                  });
                },
                "Player is due for warning",
                "Please advise the player of the Baulk line limit by announcing 'BAULK LINE WARNING AT 80'",
              );
          });
        }),
      ]),
      Divider(),
      Row(
        children: [
          bigButton(
              Text('Pass Turn',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 18,
                    color: Colors.black,
                  )),
              [
                const Color(0xffCCCACA),
                const Color(0xffA2A0A0),
              ], () {
            setState(() {
              game.passTurn();
            });
          }),
        ],
      ),
      SizedBox(height: 10.00),
      Row(
        children: [
          bigButton(
              Text('Foul',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 18,
                    color: Colors.black,
                  )),
              [
                const Color(0xffCCCACA),
                const Color(0xffA2A0A0),
              ], () {
            setState(() {
              game.foul();
            });
          }),
          SizedBox(width: 10.00),
          bigButton(
              Text('Miss',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 18,
                    color: Colors.black,
                  )),
              [
                const Color(0xffCCCACA),
                const Color(0xffA2A0A0),
              ], () {
            setState(() {
              game.miss();
            });
          }),
        ],
      ),
      SizedBox(height: 10.00),
      Row(
        children: [
          bigButton(
              Text('Undo',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 18,
                    color: Colors.black,
                  )),
              [
                const Color(0xffCCCACA),
                const Color(0xffA2A0A0),
              ], () {
            setState(() {
              game.undo();
            });
          }),
          SizedBox(width: 10.00),
          bigButton(
              Text('End Game',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 18,
                    color: Colors.black,
                  )),
              [
                const Color(0xffCCCACA),
                const Color(0xffA2A0A0),
              ], () {
            _showDialog(context, () {
              setState(() {
                game.endGame();
              });
            }, "End Game?",
                "Are you sure you to end this game? The winner will be the player with the higher score.");
          }),
        ],
      ),
      SizedBox(height: 10.00),
      Row(children: [
        bigButton(
            Text('End Match',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 18,
                  color: Colors.black,
                )),
            [
              const Color(0xffCCCACA),
              const Color(0xffA2A0A0),
            ], () {
          _showDialog(context, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: "Billiards Scorekeeper"),
                ));
          }, "End the Match?",
              "Are you sure you want to exit to the home screen?");
        }),
      ]),
    ]);
    output.add(Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: colChildren)));
    return output;
  }

  List scoreBoard({middleComponent}) {
    return [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Column(children: [
            Text(
              '${game.players[0].gamesWon}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 22,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              '${game.players[0].score}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 42,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              game.players[0].name,
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 18,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              'Break: ${game.players[0].currBreak}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              '# Hazards: ${game.players[0].consecutiveHazards}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              '# Cannons: ${game.players[0].consecutiveCannons}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              'HB: ${game.players[0].highestBreak}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            if (game.handicapped)
              Text(
                'Raw Score: ${game.players[0].rawScore}',
                style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 12,
                    fontWeight: (game.players[0].active)
                        ? FontWeight.bold
                        : FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            if (game.handicappedByTiers)
              Text(
                'Score Multiplier: ${game.players[0].multiplier}',
                style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 12,
                    fontWeight: (game.players[0].active)
                        ? FontWeight.bold
                        : FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            Text(
              'Yellow Ball',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        Expanded(
          child: Column(children: [
            Text(
              '(${game.gamesPlayed})',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            middleComponent
          ]),
        ),
        Expanded(
          child: Column(children: [
            Text(
              '${game.players[1].gamesWon}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 22,
                  fontWeight: (game.players[1].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              '${game.players[1].score}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 42,
                  fontWeight: (game.players[1].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              game.players[1].name,
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 18,
                  fontWeight: (game.players[1].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              'Break: ${game.players[1].currBreak}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[1].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              '# Hazards: ${game.players[1].consecutiveHazards}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[1].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              '# Cannons: ${game.players[1].consecutiveCannons}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[1].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              'HB: ${game.players[1].highestBreak}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[1].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            if (game.handicapped)
              Text(
                'Raw Score: ${game.players[1].rawScore}',
                style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 12,
                    fontWeight: (game.players[1].active)
                        ? FontWeight.bold
                        : FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            if (game.handicappedByTiers)
              Text(
                'Score Multiplier: ${game.players[1].multiplier}',
                style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 12,
                    fontWeight: (game.players[0].active)
                        ? FontWeight.bold
                        : FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            Text(
              'White Ball',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[1].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ]),
      SizedBox(height: 10),
      Row(
        children: [
          Expanded(
              child: Container(
            height: 10.0,
            foregroundDecoration: BoxDecoration(color: Colors.yellow),
          )),
          Expanded(
              child: Container(
            height: 10.0,
            foregroundDecoration: BoxDecoration(color: Colors.white),
          ))
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (!init) {
        game = new Game(
            widget.playerNames,
            widget.playerHandicaps,
            widget.playerTiers,
            widget.handicappedpWithTiers,
            widget.timed,
            widget.minutes,
            widget.targetScore);
        init = true;
      }
    });

    return new PopScope(
      canPop: false,
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: OrientationBuilder(builder: (context, orientation) {
            return SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Fixed scoreboard UI section
                ...scoreBoard(
                  middleComponent: (widget.timed)
                      ? new TimerC(widget.minutes).component
                      : Text("Target Score: " + widget.targetScore.toString()),
                ),
                Expanded(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...scoringInput(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
          }),
        ),
      ),
    );

//     return new PopScope(
//         canPop: false,
//         child: Scaffold(
//             body: AnnotatedRegion<SystemUiOverlayStyle>(
//           value: SystemUiOverlayStyle.light,
//           child: OrientationBuilder(builder: (context, orientation) {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Expanded(
//                   child: SafeArea(
//                     child: Container(
//                       height: MediaQuery.of(context).size.height,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                     child: Container(
//                                   height: 10.0,
//                                   foregroundDecoration:
//                                       BoxDecoration(color: Colors.yellow),
//                                 )),
//                                 Expanded(
//                                     child: Container(
//                                   height: 10.0,
//                                   foregroundDecoration:
//                                       BoxDecoration(color: Colors.white),
//                                 ))
//                               ],
//                             ),
//                             SizedBox(height: 15.00),
//                             ...scoreBoard(
//                                 middleComponent: (widget.timed)
//                                     ? new TimerC(widget.minutes).component
//                                     : Text("Target Score: " +
//                                         widget.targetScore.toString())),
//                             SizedBox(height: 15.00),
//                             Row(
//                               children: [
//                                 Expanded(
//                                     child: Container(
//                                   height: 10.0,
//                                   foregroundDecoration:
//                                       BoxDecoration(color: Colors.yellow),
//                                 )),
//                                 Expanded(
//                                     child: Container(
//                                   height: 10.0,
//                                   foregroundDecoration:
//                                       BoxDecoration(color: Colors.white),
//                                 ))
//                               ],
//                             ),
//                             ...scoringInput(context),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             );
//           }),
//         )));
  }
}

_showDialog(BuildContext context, contCallBack, title, message) {
  VoidCallback continueCallBack =
      () => {Navigator.of(context).pop(), contCallBack()};
  BlurryDialog alert = BlurryDialog(title, message, continueCallBack);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
