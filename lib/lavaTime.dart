import 'package:flutter/material.dart';

const COMMOM_DURATIONS = {
  'TEN_MINUTES': 10 * 60,
  'ONE_HOUR': 60 * 60,
  'TEN_HOURS': 10 * 60 * 60,
};

class Digit {
  int value;
  Duration timeLeftBeforeDigitUpdate;
  double initialProgress;

  Digit({
    @required this.value,
    @required this.timeLeftBeforeDigitUpdate,
    @required this.initialProgress
  }) : 
    assert(value != null, 'value is required'),
    assert(value >= 0 && value <= 9, 'value is between 0 and 9'),
    assert(timeLeftBeforeDigitUpdate != null, 'timeLeftBeforeDigitUpdate is required'),
    assert(initialProgress != null, 'initialProgress is required'),
    assert(initialProgress >= 0.0 && initialProgress <= 1.0, 'initialProgress is between 0 and 1');
}

/// Utility class to access clock digits
class LavaTime {
  Digit hourTens;
  Digit hourOnes;
  Digit minuteTens;
  Digit minuteOnes;

  LavaTime() {
    DateTime now = DateTime.now();

    hourTens = Digit(
      value: (now.hour / 10).truncate(),
      timeLeftBeforeDigitUpdate: Duration(
        seconds: COMMOM_DURATIONS['TEN_HOURS']
          - 60 * 60 * (now.hour % 10)
          - 60 * now.minute
          - now.second
      ),
      initialProgress: (
        60 * 60 * (now.hour % 10)
        + 60 * now.minute
        + now.second
      ) / COMMOM_DURATIONS['TEN_HOURS'],
    );

    hourOnes = Digit(
      value: now.hour % 10,
      timeLeftBeforeDigitUpdate: Duration(
        seconds: COMMOM_DURATIONS['ONE_HOUR']
          - 60 * now.minute
          - now.second
      ),
      initialProgress: (
        60 * now.minute
        + now.second
      ) / COMMOM_DURATIONS['ONE_HOUR'],
    );

    minuteTens = Digit(
      value: (now.minute / 10).truncate(),
      timeLeftBeforeDigitUpdate: Duration(
        seconds: COMMOM_DURATIONS['TEN_MINUTES']
          - 60 * (now.minute % 10)
          - now.second
      ),
      initialProgress: (
        60 * (now.minute % 10)
        + now.second
      ) / COMMOM_DURATIONS['TEN_MINUTES'],
    );

    minuteOnes = Digit(
      value: now.minute % 10,
      timeLeftBeforeDigitUpdate: Duration(seconds: 60 - now.second),
      initialProgress: now.second / 60,
    );
  }
}