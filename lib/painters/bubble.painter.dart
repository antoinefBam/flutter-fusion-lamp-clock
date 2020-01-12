import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/bubble.dart';

class BubblePainter extends CustomPainter {
  BubblePainter({
    @required this.bubble,
    @required this.dy,
  }) :
    assert(bubble != null, 'bubble is required'),
    assert(dy != null, 'dy is required');

  final Bubble bubble;
  final double dy;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(bubble.dx, dy),
      bubble.radius,
       Paint()
        ..color = bubble.color,
    );
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => oldDelegate.dy != dy;
}