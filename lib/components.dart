import 'package:flutter/material.dart';

Object uiColours = {
  "light_grey": const Color(0xffCCCACA),
  "dark_grey": const Color(0xffA2A0A0),
  "selected_dark_grey": const Color(0xff7E7C7C),
  "selected_light_grey": const Color(0xff9B9797),
  "purple": const Color(0xFF7D73B5),
  "gold": const Color(0xFFC3A164)
};

List<Map> balls = [
  {
    "name": "Red",
    "code": "R",
    "value": 1,
    "quantity": 15,
    "dark_colour": Color(0xff9D2C2C),
    "light_colour": Color(0xffC72D2D),
  },
  {
    "name": "Yellow",
    "code": "Y",
    "value": 2,
    "quantity": 1,
    "dark_colour": const Color(0xffCEB636),
    "light_colour": const Color(0xffE0C534),
  },
  {
    "name": "Green",
    "code": "G",
    "value": 3,
    "quantity": 1,
    "dark_colour": const Color(0xff397140),
    "light_colour": const Color(0xff4CA256),
  },
  {
    "name": "Brown",
    "code": "br",
    "value": 4,
    "quantity": 1,
    "dark_colour": const Color(0xff694A20),
    "light_colour": const Color(0xffB48247),
  },
  {
    "name": "Blue",
    "code": "bl",
    "value": 5,
    "quantity": 1,
    "dark_colour": const Color(0xff2F4EB4),
    "light_colour": const Color(0xff5271D6),
  },
  {
    "name": "Pink",
    "code": "P",
    "value": 6,
    "quantity": 1,
    "dark_colour": const Color(0xff9B3D9B),
    "light_colour": const Color(0xffE066BA),
  },
  {
    "name": "Black",
    "code": "B",
    "value": 7,
    "quantity": 1,
    "dark_colour": const Color(0xff0B0B0B),
    "light_colour": const Color(0xff393939),
  },
];

Widget bigButton(child, gradientValues, pressed) {
  return Expanded(
      child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18.0),
      gradient: LinearGradient(
        begin: Alignment(1.0, -1.92),
        end: Alignment(-0.94, 1.75),
        colors: gradientValues,
        stops: [0.0, 1.0],
      ),
    ),
    child: RawMaterialButton(
      onPressed: pressed,
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    ),
  ));
}

List<Color> freeBallInputColour(condition) {
  if (condition) {
    return [const Color(0xff9B9797), const Color(0xff7E7C7C)];
  } else {
    return [const Color(0xffCCCACA), const Color(0xffA2A0A0)];
  }
}

Widget returnScoreLine(player, width) {
  return Container(
    height: double.infinity,
    width: width,
    color: Color(0xFF888888),
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FractionallySizedBox(
          widthFactor: 1,
          heightFactor: player.maxScoreFraction,
          child: Container(
              color: Color(0xFFCCCCCC),
              child: Padding(
                padding: (player.maxScoreFraction < 1)
                    ? const EdgeInsets.only(top: 8.0)
                    : const EdgeInsets.only(top: 36.0),
                child: Text('${player.maxScore}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black)),
              )),
        ),
        FractionallySizedBox(
          widthFactor: 1,
          heightFactor: player.snookersReqdFractionOfMax,
          child: Container(
              //color: Color(0xFFCCCCCC),
              decoration: BoxDecoration(
                color: Color(0xFFCCCCCC),
                border: Border(
                  top: BorderSide(
                      width: 4.0, color: player.winningScorelineColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${player.snookersReqdScoreline}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black)),
              )),
        ),
        FractionallySizedBox(
          widthFactor: 1,
          heightFactor: player.scoreFractionOfMax,
          child: Container(
              color: Color(0xFF7D73B5),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${player.score}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              )),
        ),
      ],
    ),
  );
}

Widget ballButton(text, gradientValues, cb) {
  return Expanded(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            gradient: LinearGradient(
              begin: Alignment(1.0, -1.92),
              end: Alignment(-0.94, 1.75),
              colors: gradientValues,
              stops: [0.0, 1.0],
            ),
          ),
          child: MaterialButton(
              onPressed: cb,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                child: Text('$text',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 22,
                      color: Colors.white,
                    )),
              ))));
}
