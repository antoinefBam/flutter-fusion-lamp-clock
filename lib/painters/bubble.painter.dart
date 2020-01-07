import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/clockDigit.dart';

class BubblePainter extends CustomPainter {
  BubblePainter({
    @required this.progress,
    @required this.color,
  }) :
    assert(progress != null, 'progress is required'),
    assert(progress >= 0.0 && progress <= 1.0, 'progress is between 0 and 1'),
    assert(color != null, 'color is required');

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(ANIMATION_CONTAINER_WIDTH / 2, (1 - progress) * ANIMATION_CONTAINER_HEIGHT),
      5.0,
       Paint()
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => oldDelegate.progress != progress;
}