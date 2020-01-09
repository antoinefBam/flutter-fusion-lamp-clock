import 'package:flutter/material.dart';

class Bubble {
  final AnimationController animationController;
  final double radius;
  final Color color;
  final double dx;
  Animation<double> animation;

  Bubble({
    @required this.animationController,
    @required this.radius,
    @required this.color,
    @required this.dx,
  }) : assert(animationController != null, 'digianimationControllert is required'),
  assert(radius != null, 'radius is required'),
  assert(color != null, 'color is required'),
  assert(dx != null, 'dx is required')
  {
    this.animation = Tween(begin: 0.0, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.linearToEaseOut,
        ),
      );
  }
}