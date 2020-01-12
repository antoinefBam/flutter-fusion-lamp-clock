import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/digit.dart';

class LoaderPainter extends CustomPainter {
  LoaderPainter({
    @required this.progress,
    @required this.liquidSurface,
    @required this.color,
    @required this.backgroundColor,
    @required this.viewBox,
    this.clearCanvas = false,
  }) :
    assert(progress != null, 'progress is required'),
    assert(progress >= 0.0 && progress <= 1.0, 'progress is between 0 and 1'),
    assert(liquidSurface != null, 'liquidSurface is required'),
    assert(color != null, 'color is required'),
    assert(backgroundColor != null, 'backgroundColor is required'),
    assert(viewBox != null, 'viewBox is required');

  final double progress;
  final double liquidSurface;
  final Color color;
  final Color backgroundColor;
  final bool clearCanvas;
  final ViewBox viewBox;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final height = (1.0 - progress) * viewBox.height;
    path.moveTo(viewBox.width, viewBox.height);
    path.lineTo(viewBox.width, height);
    path.quadraticBezierTo(
      viewBox.width * 3 / 4,
      height - liquidSurface,
      viewBox.width / 2,
      height,
    );
    path.quadraticBezierTo(
      viewBox.width / 4,
      height + liquidSurface,
      0.0,
      height,
    );
    path.lineTo(0.0, viewBox.height);
    path.close();

    canvas.drawPath(
      path, Paint()
        ..color = clearCanvas ? backgroundColor : color
    );
  }

  @override
  bool shouldRepaint(LoaderPainter oldDelegate) => oldDelegate.progress != progress;
}