import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gameview.dart';
import 'components.dart';

class Timer {
  // NAME
  int secondsRemaining = 0;
  int minutes = 0;
  Widget component = Text('Loading');
  CountdownController _controller = new CountdownController(autoStart: true);

  Timer(this.minutes) {
    secondsRemaining = this.minutes * 60;

    this.component = Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Start
            ElevatedButton(
              child: Text('Start'),
              onPressed: () {
                _controller.start();
              },
            ),
            // Pause
            ElevatedButton(
              child: Text('Pause'),
              onPressed: () {
                _controller.pause();
              },
            ),
            // Resume
            ElevatedButton(
              child: Text('Resume'),
              onPressed: () {
                _controller.resume();
              },
            ),
            // Stop
            ElevatedButton(
              child: Text('Restart'),
              onPressed: () {
                _controller.restart();
              },
            ),
          ],
        ),
      ),
      Countdown(
          controller: _controller,
          seconds: this.secondsRemaining,
          build: (_, double time) => Text(
                time.toString(),
                style: TextStyle(
                  fontSize: 100,
                ),
              ),
          interval: Duration(milliseconds: 100),
          onFinished: () {
            return Text('Timer is done!');
          })
    ]);
    ;
  }
}
