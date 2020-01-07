import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/clockDigit.dart';

class LoaderPainter extends CustomPainter {
  LoaderPainter({
    @required this.progress,
    @required this.color,
    @required this.backgroundColor,
    this.clearCanvas = false,
  }) :
    assert(progress != null, 'progress is required'),
    assert(progress >= 0.0 && progress <= 1.0, 'progress is between 0 and 1'),
    assert(color != null, 'color is required'),
    assert(backgroundColor != null, 'backgroundColor is required');

  final double progress;
  final Color color;
  final Color backgroundColor;
  final bool clearCanvas;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          const Offset(ANIMATION_CONTAINER_WIDTH, ANIMATION_CONTAINER_HEIGHT),
          Offset(0, (1.0 - progress) * ANIMATION_CONTAINER_HEIGHT),
        ),
        Radius.circular(5.0),
      ),
      Paint()
        ..color = clearCanvas ? backgroundColor : color,
    );
  }

  @override
  bool shouldRepaint(LoaderPainter oldDelegate) => oldDelegate.progress != progress;
}