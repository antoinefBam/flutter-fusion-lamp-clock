import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/lavaTime.dart';
import 'package:lava_lamp_clock/painters/bubble.painter.dart';
import 'package:lava_lamp_clock/painters/loader.painter.dart';

const ANIMATION_CONTAINER_HEIGHT = 150.0;
const ANIMATION_CONTAINER_WIDTH = 75.0;

class Bubble {
  final AnimationController animationController;
  final double radius;
  final Color color;
  final Duration delay;
  final double dx;
  Animation<double> animation;

  Bubble({
    @required this.animationController,
    @required this.radius,
    @required this.color,
    @required this.delay,
    @required this.dx,
  }) {
    this.animation = Tween(begin: 0.0, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.linearToEaseOut,
        ),
      );
  }
}

class ClockDigit extends StatefulWidget {
  const ClockDigit({
    Key key,
    @required this.digit,
    @required this.title,
    @required this.color,
    @required this.textColor,
    @required this.backgroundColor,
    @required this.bubbleNumber,
  }) : 
  assert(digit != null, 'digit is required'),
  assert(title != null, 'title is required'),
  assert(color != null, 'color is required'),
  assert(textColor != null, 'textColor is required'),
  assert(backgroundColor != null, 'backgroundColor is required'),
  assert(bubbleNumber != null, 'bubbleNumber is required'),
  super(key: key);

  final Digit digit;
  final String title;
  final Color color;
  final Color textColor;
  final Color backgroundColor;
  final int bubbleNumber;

  @override
  _ClockDigitState createState() => _ClockDigitState();
}

class _ClockDigitState extends State<ClockDigit> with TickerProviderStateMixin {
  AnimationController _loaderAnimationController;
  Animation<double> _loaderAnimation;
  List<Bubble> _bubbles;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(ClockDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit.value != widget.digit.value) {
      _init();
    }
  }

  @override
  void dispose() {
    _loaderAnimationController.dispose();
    for (final bubble in _bubbles) {
      bubble.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.display1.copyWith(color: widget.textColor),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: ANIMATION_CONTAINER_HEIGHT,
                width: ANIMATION_CONTAINER_WIDTH,
                color: widget.color.withOpacity(0.2),
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _loaderAnimation,
                      builder: (_, child) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: LoaderPainter(
                            progress: _loaderAnimation.value,
                            color: widget.color,
                            backgroundColor: widget.backgroundColor,
                            clearCanvas: _loaderAnimation.isCompleted,
                          ),
                        );
                      },
                    ),
                    ..._bubbles.map((bubble) => AnimatedBuilder(
                      animation: bubble.animation,
                      builder: (_, child) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: BubblePainter(
                            color: bubble.color,
                            radius: bubble.radius,
                            dx: bubble.dx,
                            dy: (1 - bubble.animation.value) * ANIMATION_CONTAINER_HEIGHT - bubble.radius,
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: bubble.color,
                        radius: bubble.radius,
                      ),
                    ),
                    ),
                  ],
                ),
            ),
          ),
        ),
        Text(
          widget.digit.value.toString(),
          style: TextStyle(fontSize: 30, color: widget.color),
        ),
      ],
    );
  }

  void _init() {
    _loaderAnimationController = AnimationController(
      duration: widget.digit.timeLeftBeforeDigitUpdate,
      vsync: this,
    );
    _loaderAnimation = Tween(begin: widget.digit.initialProgress, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: _loaderAnimationController,
          curve: Curves.linear,
        ),
      );

    _bubbles = List.generate(
      widget.bubbleNumber,
      (_) => _initBubble(),
    );

    _loaderAnimationController.forward().orCancel;
    for (final bubble in _bubbles) {
      Future.delayed(bubble.delay, () {
        bubble.animationController.repeat().orCancel;
      });
    }
  }

  Bubble _initBubble() {
    final randomNumberGenerator = Random();
    final radius = (1.0 + randomNumberGenerator.nextDouble() * 9.0);
    final animationController = AnimationController(
      duration: Duration(seconds: (3 + randomNumberGenerator.nextInt(12))),
      vsync: this,
    );
    final dx = radius + randomNumberGenerator.nextDouble() * (ANIMATION_CONTAINER_WIDTH - radius);
    final delay = Duration(seconds: randomNumberGenerator.nextInt(30));
    return Bubble(
      animationController: animationController,
      color: widget.color,
      radius: radius,
      dx: dx,
      delay: delay,
    );
  } 
}

