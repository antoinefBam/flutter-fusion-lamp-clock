import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/paths/0.dart';
import 'package:lava_lamp_clock/paths/1.dart';
import 'package:lava_lamp_clock/paths/2.dart';
import 'package:lava_lamp_clock/paths/3.dart';
import 'package:lava_lamp_clock/paths/4.dart';
import 'package:lava_lamp_clock/paths/5.dart';
import 'package:lava_lamp_clock/paths/6.dart';
import 'package:lava_lamp_clock/paths/7.dart';
import 'package:lava_lamp_clock/paths/8.dart';
import 'package:lava_lamp_clock/paths/9.dart';
import 'package:path_drawing/path_drawing.dart';


class DigitPainter extends CustomPainter {
  DigitPainter({
    @required this.digit,
  }) :
    assert(digit != null, 'digit is required'),
    assert(digit >= 0 && digit <= 9, 'progress is between 0 and 9');

  final int digit;

  @override
  void paint(Canvas canvas, Size size) {
    String svgPath;
    switch (digit) {
      case 0:
        svgPath = zeroPath;
        break;
      case 1:
        svgPath = onePath;
        break;
      case 2:
        svgPath = twoPath;
        break;
      case 3:
        svgPath = threePath;
        break;
      case 4:
        svgPath = fourPath;
        break;
      case 5:
        svgPath = fivePath;
        break;
      case 6:
        svgPath = sixPath;
        break;
      case 7:
        svgPath = sevenPath;
        break;
      case 8:
        svgPath = heightPath;
        break;
      case 9:
        svgPath = ninePath;
        break;
      default:
        svgPath = '';
    }
    final path = parseSvgPathData(svgPath);

    canvas.drawPath(
      path.shift(Offset(-6.0, -6.0)),
      Paint()
        ..color = Color(0xFF676767),
    );
  }

  @override
  bool shouldRepaint(DigitPainter oldDelegate) => oldDelegate.digit != digit;
}