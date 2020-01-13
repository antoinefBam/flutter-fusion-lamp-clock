import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_morph/path_morph.dart';
import 'package:lava_lamp_clock/bubble.dart';
import 'package:lava_lamp_clock/digit.dart';
import 'package:lava_lamp_clock/digitClipper.dart';
import 'package:lava_lamp_clock/painters/bubble.painter.dart';
import 'package:lava_lamp_clock/painters/outline.painter.dart';
import 'package:lava_lamp_clock/painters/loader.painter.dart';

const MIN_BUBBLE_RADIUS = 1.0;
const MAX_BUBBLE_RADIUS = 8.0;

const MIN_BUBBLE_DURATION = 6;
const MAX_BUBBLE_DURATION = 18;

class ClockDigit extends StatefulWidget {
  final Digit digit;
  final Color color;
  final Color backgroundColor;
  final Color outlineColor;
  final double bubbleFrequency;

  const ClockDigit({
    Key key,
    @required this.digit,
    @required this.color,
    @required this.backgroundColor,
    @required this.outlineColor,
    @required this.bubbleFrequency,
  }) : 
  assert(digit != null, 'digit is required'),
  assert(color != null, 'color is required'),
  assert(backgroundColor != null, 'backgroundColor is required'),
  assert(outlineColor != null, 'outlineColor is required'),
  assert(bubbleFrequency != null, 'bubbleFrequency is required'),
  assert(bubbleFrequency >= 0 && bubbleFrequency <= 1, 'bubbleFrequency is between 0 and 1'),
  super(key: key);

  @override
  _ClockDigitState createState() => _ClockDigitState();
}

class _ClockDigitState extends State<ClockDigit> with TickerProviderStateMixin {
  AnimationController _loaderAnimationController;
  Animation<double> _loaderAnimation;
  AnimationController _liquidSurfaceAnimationController;
  Animation<double> _liquidSurfaceAnimation;
  List<Bubble> _bubbles;

  SampledPathData data;
  AnimationController controller;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void func(int i, Offset z) {
    setState((){
      data.shiftedPoints[i] = z;
    });
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
    _liquidSurfaceAnimationController.dispose();
    for (final bubble in _bubbles) {
      bubble.animationController.dispose();
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRect(
        clipper: DigitBoxClipper(widget.digit.viewBox),
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: DigitClipper(
                PathMorph.generatePath(data),
              ),
              child: AnimatedContainer(
                duration: Duration(seconds: 2),
                height: widget.digit.viewBox.height,
                width: widget.digit.viewBox.width,
                color: widget.color.withOpacity(0.2),
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _loaderAnimation,
                      builder: (_, child) {
                        return AnimatedBuilder(
                          animation: _liquidSurfaceAnimation,
                          builder: (_, child) {
                            return CustomPaint(
                              size: Size.infinite,
                              painter: LoaderPainter(
                                progress: _loaderAnimation.value,
                                liquidSurface: _liquidSurfaceAnimation.value,
                                color: widget.color,
                                backgroundColor: widget.backgroundColor,
                                clearCanvas: _loaderAnimation.isCompleted,
                                viewBox: widget.digit.viewBox,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ..._bubbles.map((bubble) => AnimatedBuilder(
                      animation: bubble.animation,
                      builder: (_, child) {
                        bubble.animationController.forward();
                        final dy = (1 - bubble.animation.value) * (widget.digit.viewBox.height + bubble.radius) - bubble.radius;
                        return CustomPaint(
                          size: Size.infinite,
                          painter: BubblePainter(
                            bubble: bubble,
                            dy: dy,
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: bubble.color,
                        radius: bubble.radius,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(seconds: 2),
              height: widget.digit.viewBox.height,
              width: widget.digit.viewBox.width,
              child: CustomPaint(
                size: Size.infinite,
                painter: OutlinePainter(
                  path: PathMorph.generatePath(data),
                  color: widget.outlineColor,
                ),
              ),
            ),
          ],  
        ),
      ),
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
    _loaderAnimationController.forward().orCancel;

    _liquidSurfaceAnimationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _liquidSurfaceAnimation = Tween(begin: -7.0, end: 7.0)
      .animate(
        CurvedAnimation(
          parent: _liquidSurfaceAnimationController,
          curve: Curves.linear,
        ),
      );
    _liquidSurfaceAnimationController.repeat(reverse: true).orCancel;

    _bubbles = [];
    final timer = Timer.periodic(Duration(seconds: 1), (_) {
      final randomNumberGenerator = Random();
      if (randomNumberGenerator.nextDouble() >= (1.0 - widget.bubbleFrequency)) {
        setState(() {
          _bubbles.add(_initBubble());
        });
      }
    });
    Future.delayed(widget.digit.timeLeftBeforeDigitUpdate, () {
      timer.cancel();
    });

    data = PathMorph.samplePaths(widget.digit.path, widget.digit.nextPath);
    controller = AnimationController(vsync: this,
        duration: Duration(seconds: 2));
    PathMorph.generateAnimations(controller, data, func);
    Future.delayed(widget.digit.timeLeftBeforeDigitUpdate - Duration(seconds: 2), () {
      controller.forward();
    });
  }

  Bubble _initBubble() {
    final randomNumberGenerator = Random();
    final radius = (MIN_BUBBLE_RADIUS + randomNumberGenerator.nextDouble() * (MAX_BUBBLE_RADIUS - MIN_BUBBLE_RADIUS));
    final animationController = AnimationController(
      duration: Duration(seconds: (MIN_BUBBLE_DURATION + randomNumberGenerator.nextInt(MAX_BUBBLE_DURATION - MIN_BUBBLE_DURATION))),
      vsync: this,
    );
    final dx = radius + randomNumberGenerator.nextDouble() * (widget.digit.viewBox.width - radius);
    return Bubble(
      animationController: animationController,
      color: widget.color,
      radius: radius,
      dx: dx,
    );
  } 
}

