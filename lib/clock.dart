import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/clockDigit.dart';
import 'package:lava_lamp_clock/lavaTime.dart';

enum _Element {
  background,
  text,
  shadow,
  color1,
  color2,
  color3,
  color4,
}

final _lightTheme = {
  _Element.background: Colors.white70,
  _Element.text: Colors.black,
  _Element.shadow: Colors.black87,
  _Element.color1: Colors.blue,
  _Element.color2: Colors.lightBlue,
  _Element.color3: Colors.green,
  _Element.color4: Colors.lightGreen,
};

final _darkTheme = {
  _Element.background: Colors.black87,
  _Element.text: Colors.white,
  _Element.shadow: Colors.white70,
  _Element.color1: Colors.deepOrange,
  _Element.color2: Colors.orange,
  _Element.color3: Colors.deepPurple,
  _Element.color4: Colors.purple,
};

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
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    return Container(
      padding: EdgeInsets.all(50),
      color: colors[_Element.background],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Columns for the clock
          ClockDigit(
            digit: _now.hourTens,
            title: 'H',
            color: colors[_Element.color1],
            backgroundColor: colors[_Element.background],
            textColor: colors[_Element.text],
            bubbleNumber: 3,
          ),
          ClockDigit(
            digit: _now.hourOnes,
            title: 'h',
            color: colors[_Element.color2],
            backgroundColor: colors[_Element.background],
            textColor: colors[_Element.text],
            bubbleNumber: 5,
          ),
          SizedBox(width: 50),
          ClockDigit(
            digit: _now.minuteTens,
            title: 'M',
            color: colors[_Element.color3],
            backgroundColor: colors[_Element.background],
            textColor: colors[_Element.text],
            bubbleNumber: 10,
          ),
          ClockDigit(
            digit: _now.minuteOnes,
            title: 'm',
            color: colors[_Element.color4],
            backgroundColor: colors[_Element.background],
            textColor: colors[_Element.text],
            bubbleNumber: 15,
          ),
        ],
      ),
    );
  }
}