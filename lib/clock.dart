import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/clockDigit.dart';
import 'package:lava_lamp_clock/clockSeparator.dart';
import 'package:lava_lamp_clock/clockTime.dart';

enum _Element {
  background,
  color,
  outline,
}

final _lightTheme = {
  _Element.background: Color(0xFFF1F3F6),
  _Element.color: Color(0xFFEAA89A),
  _Element.outline: Color(0xFF676767),
};

final _darkTheme = {
  _Element.background: Color(0xFF414141),
  _Element.color: Color(0xFFC4C4C4),
  _Element.outline: Color(0xFFFFFFFF),
};

class Clock extends StatefulWidget {
  Clock({Key key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  ClockTime _now = ClockTime();

  // Tick the clock
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _now = ClockTime();
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
      padding: EdgeInsets.all(50.0),
      color: colors[_Element.background],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Columns for the clock
          ClockDigit(
            digit: _now.hourTens,
            color: colors[_Element.color],
            backgroundColor: colors[_Element.background],
            outlineColor: colors[_Element.outline],
            bubbleFrequency: 0.2,
          ),
          ClockDigit(
            digit: _now.hourOnes,
            color: colors[_Element.color],
            backgroundColor: colors[_Element.background],
            outlineColor: colors[_Element.outline],
            bubbleFrequency: 0.4,
          ),
          ClockSeparator(
            color: colors[_Element.color],
            backgroundColor: colors[_Element.background],
            outlineColor: colors[_Element.outline],
          ),
          ClockDigit(
            digit: _now.minuteTens,
            color: colors[_Element.color],
            backgroundColor: colors[_Element.background],
            outlineColor: colors[_Element.outline],
            bubbleFrequency: 0.6,
          ),
          ClockDigit(
            digit: _now.minuteOnes,
            color: colors[_Element.color],
            backgroundColor: colors[_Element.background],
            outlineColor: colors[_Element.outline],
            bubbleFrequency: 0.8,
          ),
        ],
      ),
    );
  }
}