import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/clockDigit.dart';
import 'package:lava_lamp_clock/lavaTime.dart';

class Clock extends StatefulWidget {
  Clock({Key key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  LavaTime _now = LavaTime();

  // Tick the clock
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _now = LavaTime();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Columns for the clock
          ClockDigit(
            digit: _now.hourTens,
            title: 'H',
            color: Colors.blue,
          ),
          ClockDigit(
            digit: _now.hourOnes,
            title: 'h',
            color: Colors.lightBlue,
          ),
          SizedBox(width: 50),
          ClockDigit(
            digit: _now.minuteTens,
            title: 'M',
            color: Colors.green,
          ),
          ClockDigit(
            digit: _now.minuteOnes,
            title: 'm',
            color: Colors.lightGreen,
          ),
        ],
      ),
    );
  }
}