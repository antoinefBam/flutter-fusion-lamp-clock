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

class DigitClipper extends CustomClipper<Path> {
  const DigitClipper(this.digit);

  final int digit;

  @override
  Path getClip(Size size) {
    String svgPath;
    switch (digit) {
      case 0:
        svgPath = zeroPlainPath;
        break;
      case 1:
        svgPath = onePlainPath;
        break;
      case 2:
        svgPath = twoPlainPath;
        break;
      case 3:
        svgPath = threePlainPath;
        break;
      case 4:
        svgPath = fourPlainPath;
        break;
      case 5:
        svgPath = fivePlainPath;
        break;
      case 6:
        svgPath = sixPlainPath;
        break;
      case 7:
        svgPath = sevenPlainPath;
        break;
      case 8:
        svgPath = heightPlainPath;
        break;
      case 9:
        svgPath = ninePlainPath;
        break;
      default:
        svgPath = '';
    }
    final path = parseSvgPathData(svgPath);
    final Rect pathBounds = path.getBounds();
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(size.width / pathBounds.width, size.height / pathBounds.height);
    return path.transform(matrix4.storage);// p
  }

  @override
  bool shouldReclip(DigitClipper oldClipper) => oldClipper.digit != digit;
}