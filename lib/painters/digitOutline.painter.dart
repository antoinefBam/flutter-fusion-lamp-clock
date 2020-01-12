import 'package:flutter/material.dart';

class DigitOutlinePainter extends CustomPainter {
  DigitOutlinePainter({
    @required this.path,
    @required this.color,
  }) :
    assert(path != null, 'path is required'),
    assert(color != null, 'color is required');

  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      path.shift(Offset(-6.0, -6.0)),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(DigitOutlinePainter oldDelegate) => oldDelegate.path != path;
}