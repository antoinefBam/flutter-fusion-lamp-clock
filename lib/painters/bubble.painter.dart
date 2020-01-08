import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  BubblePainter({
    @required this.color,
    @required this.radius,
    @required this.dx,
    @required this.dy,
  }) :
    assert(color != null, 'color is required'),
    assert(radius != null, 'radius is required'),
    assert(dx != null, 'dx is required'),
    assert(dy != null, 'dy is required');

  final Color color;
  final double radius;
  final double dx;
  final double dy;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(dx, dy),
      radius,
       Paint()
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => oldDelegate.dy != dy;
}