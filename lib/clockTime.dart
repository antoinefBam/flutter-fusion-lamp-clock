import 'package:lava_lamp_clock/digit.dart';

const COMMOM_DURATIONS = {
  'TEN_MINUTES': 10 * 60,
  'ONE_HOUR': 60 * 60,
  'TEN_HOURS': 10 * 60 * 60,
};

/// Utility class to access clock digits
class ClockTime {
  Digit hourTens;
  Digit hourOnes;
  Digit minuteTens;
  Digit minuteOnes;

  ClockTime() {
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