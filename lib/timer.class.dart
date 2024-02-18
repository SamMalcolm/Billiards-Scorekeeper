import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final int minutes;

  const CountdownTimer({Key? key, required this.minutes}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _remainingTimeInSeconds;
  late Timer _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _remainingTimeInSeconds = widget.minutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_remainingTimeInSeconds > 0) {
            _remainingTimeInSeconds--;
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  String _formatTime(int timeInSeconds) {
    int hours = timeInSeconds ~/ 3600;
    int minutes = (timeInSeconds ~/ 60) % 60;
    int seconds = timeInSeconds % 60;

    String hoursStr =
        (hours > 0) ? '${hours.toString().padLeft(2, '0')}: ' : '';
    String minutesStr = '${minutes.toString().padLeft(2, '0')}:';
    String secondsStr = '${seconds.toString().padLeft(2, '0')}';

    return '$hoursStr$minutesStr$secondsStr';
  }

  void _restartTimer() {
    setState(() {
      _remainingTimeInSeconds = widget.minutes * 60;
      _isPaused = false;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Time Remaining:',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Text(
          _formatTime(_remainingTimeInSeconds),
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: () {
                setState(() {
                  _isPaused = !_isPaused;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _restartTimer();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class TimerC {
  // NAME
  int secondsRemaining = 0;
  int minutes = 0;
  Widget component = Text('Loading');

  TimerC(this.minutes) {
    secondsRemaining = this.minutes * 60;

    this.component = CountdownTimer(minutes: this.minutes);
  }
}
