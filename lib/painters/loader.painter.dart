import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/clockDigit.dart';

class LoaderPainter extends CustomPainter {
  LoaderPainter({
    @required this.progress,
    @required this.liquidSurface,
    @required this.color,
    @required this.backgroundColor,
    this.clearCanvas = false,
  }) :
    assert(progress != null, 'progress is required'),
    assert(progress >= 0.0 && progress <= 1.0, 'progress is between 0 and 1'),
    assert(liquidSurface != null, 'liquidSurface is required'),
    assert(color != null, 'color is required'),
    assert(backgroundColor != null, 'backgroundColor is required');

  final double progress;
  final double liquidSurface;
  final Color color;
  final Color backgroundColor;
  final bool clearCanvas;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final height = (1.0 - progress) * ANIMATION_CONTAINER_HEIGHT;
    path.moveTo(ANIMATION_CONTAINER_WIDTH, ANIMATION_CONTAINER_HEIGHT);
    path.lineTo(ANIMATION_CONTAINER_WIDTH, height);
    path.quadraticBezierTo(
      ANIMATION_CONTAINER_WIDTH * 3 / 4,
      height - liquidSurface,
      ANIMATION_CONTAINER_WIDTH / 2,
      height,
    );
    path.quadraticBezierTo(
      ANIMATION_CONTAINER_WIDTH / 4,
      height + liquidSurface,
      0.0,
      height,
    );
    path.lineTo(0.0, ANIMATION_CONTAINER_HEIGHT);
    path.close();

    canvas.drawPath(
      path, Paint()
        ..color = clearCanvas ? backgroundColor : color
    );
  }

  @override
  bool shouldRepaint(LoaderPainter oldDelegate) => oldDelegate.progress != progress;
}