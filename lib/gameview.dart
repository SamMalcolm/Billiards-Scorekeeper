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

  List<Widget> foulButtons() {
    List<Widget> result = [];
    for (int i = 4; i < 8; i++) {
      result.add(bigButton(
          Text('$i',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 22,
                color: Colors.white,
              )),
          [
            const Color(0xffCCCACA),
            const Color(0xffA2A0A0),
          ], () {
        setState(() {
          foulInput = false;
          game.foul(i);
        });
      }));
      if (i != 7) {
        result.add(SizedBox(width: 10.00));
      }
    }
    return result;
  }

  List scoringInput(context) {
    return [
      Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(children: [
            Divider(),
            Text("Two Point Scores"),
            SizedBox(height: 10.00),
            Row(children: [
              bigButton(
                  Text('Winning Hazard (Potting Opponent)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 22,
                        color: Colors.white,
                      )),
                  [
                    Color.fromARGB(255, 225, 183, 14),
                    Color.fromARGB(255, 197, 156, 11),
                  ],
                  null),
            ]),
            SizedBox(height: 10.00),
            Row(children: [
              bigButton(
                  Text('Losing Hazard (In-Off Opponent)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 22,
                        color: Colors.white,
                      )),
                  [
                    Color.fromARGB(255, 225, 183, 14),
                    Color.fromARGB(255, 197, 156, 11),
                  ],
                  null),
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
                    Color.fromARGB(255, 225, 183, 14),
                    const Color(0xff9D2C2C),
                  ],
                  null),
            ]),
            Divider(),
            Text("Three Point Scores"),
            SizedBox(height: 10.00),
            Row(children: [
              bigButton(
                  Text('Winning Hazard (Potting Red)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 22,
                        color: Colors.white,
                      )),
                  [
                    const Color(0xffC72D2D),
                    const Color(0xff9D2C2C),
                  ],
                  null),
            ]),
            SizedBox(height: 10.00),
            Row(
              children: [
                bigButton(
                    Text('Losing Hazard (In-Off Red)',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Helvetica Neue',
                          fontSize: 22,
                          color: Colors.white,
                        )),
                    [
                      const Color(0xffC72D2D),
                      const Color(0xff9D2C2C),
                    ],
                    null),
              ],
            ),
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
                  ],
                  () {}),
            ]),
            Divider(),
            SizedBox(height: 10.00),
            Row(
              children: [
                bigButton(
                    Text('Foul',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Helvetica Neue',
                          fontSize: 18,
                          color: Colors.white,
                        )),
                    [
                      const Color(0xffCCCACA),
                      const Color(0xffA2A0A0),
                    ], () {
                  setState(() {});
                })
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
                          color: Colors.white,
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
                    Text('Concede',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Helvetica Neue',
                          fontSize: 18,
                          color: Colors.white,
                        )),
                    [
                      const Color(0xffCCCACA),
                      const Color(0xffA2A0A0),
                    ], () {
                  _showDialog(context, () {
                    setState(() {
                      game.endGame();
                    });
                  }, "Concede Game?", "Are you sure you to end this game?");
                }),
              ],
            ),
            SizedBox(height: 10.00),
            Row(
              children: [
                bigButton(
                    Text('Pass Turn',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Helvetica Neue',
                          fontSize: 18,
                          color: Colors.white,
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
            Row(children: [
              bigButton(
                  Text('End Match',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 18,
                        color: Colors.white,
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
          ]))
    ];
  }

  List scoreBoard() {
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
              'HB: ${game.players[0].highestBreak}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
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
              'HB: ${game.players[1].highestBreak}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[1].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              'Raw Score: ${game.players[1].rawScore}',
              style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 12,
                  fontWeight: (game.players[0].active)
                      ? FontWeight.bold
                      : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
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
          ]),
        ),
      ]),
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

    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: OrientationBuilder(builder: (context, orientation) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.00),
                        if (widget.timed) new Timer(widget.minutes).component,
                        ...scoreBoard(),
                        ...scoringInput(context),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    ));
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
