import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game.class.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'components.dart';
import 'blurryDialog.dart';
import 'main.dart';

class GameView extends StatefulWidget {
  GameView(
      {Key? key,
      required this.playerNames,
      required this.playerHandicaps,
      required this.playerTiers,
      required this.handicap,
      required this.handicappedpWithTiers})
      : super(key: key);

  final List playerNames;
  final List playerHandicaps;
  final List playerTiers;
  final bool handicap;
  final bool handicappedpWithTiers;

  @override
  _GameView createState() => _GameView();
}

class _GameView extends State<GameView> {
  num? redsRemaining = 15;
  Game game = new Game(["default", "default2"], [0, 0]);
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
            Row(children: [
              bigButton(
                  Text('+1',
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
              SizedBox(width: 10.00),
              Expanded(
                  child: Row(
                children: [
                  bigButton(
                      Text('+',
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
                      () {}),
                  SizedBox(width: 10.00),
                  bigButton(
                      Text('-',
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
                    setState(() {});
                  }),
                ],
              ))
            ]),

            //

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  ballButton(
                      '+2',
                      [
                        const Color(0xffE0C534),
                        const Color(0xffCEB636),
                      ],
                      null),
                  SizedBox(width: 10.00),
                  ballButton(
                      '+3',
                      [
                        const Color(0xff4CA256),
                        const Color(0xff397140),
                      ],
                      null),
                  SizedBox(width: 10.00),
                  ballButton(
                    '+4',
                    [
                      const Color(0xffB48247),
                      const Color(0xff694A20),
                    ],
                    null,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  ballButton(
                      '+5',
                      [
                        const Color(0xff5271D6),
                        const Color(0xff2F4EB4),
                      ],
                      null),
                  SizedBox(width: 10.00),
                  ballButton(
                      '+6',
                      [
                        const Color(0xffE066BA),
                        const Color(0xff9B3D9B),
                      ],
                      null),
                  SizedBox(width: 10.00),
                  ballButton(
                      '+7',
                      [
                        const Color(0xff393939),
                        const Color(0xff0B0B0B),
                      ],
                      null),
                ],
              ),
            ),
            SizedBox(height: 10.00),
            if (!foulInput)
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
                    setState(() {
                      foulInput = true;
                    });
                  })
                ],
              ),
            if (foulInput)
              Row(
                children: [...foulButtons()],
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
                  }, "Concede Frame?", "Are you sure you to end this frame?");
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
                SizedBox(width: 10.00),
                bigButton(
                    Text('Free Ball',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Helvetica Neue',
                          fontSize: 18,
                          color: Colors.white,
                        )),
                    freeBallInputColour(fb), () {
                  setState(() {
                    fb = !fb;
                  });
                })
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
          ]),
        ),
        Expanded(
          child: Column(children: [
            Text(
              '()',
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
          ]),
        ),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (!init) {
        game = new Game(widget.playerNames, widget.playerHandicaps);
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
