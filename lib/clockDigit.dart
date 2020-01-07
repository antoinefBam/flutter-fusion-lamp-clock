import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/lavaTime.dart';
import 'package:lava_lamp_clock/painters/bubble.painter.dart';
import 'package:lava_lamp_clock/painters/loader.painter.dart';

const ANIMATION_CONTAINER_HEIGHT = 150.0;
const ANIMATION_CONTAINER_WIDTH = 45.0;

class ClockDigit extends StatefulWidget {
  const ClockDigit({
    Key key,
    @required this.digit,
    @required this.title,
    @required this.color,
    this.textColor,
    this.backgroundColor,
  }) : 
  assert(digit != null, 'digit is required'),
  assert(title != null, 'title is required'),
  assert(color != null, 'color is required'),
  super(key: key);

  final Digit digit;
  final String title;
  final Color color;
  final Color textColor;
  final Color backgroundColor;

  @override
  _ClockDigitState createState() => _ClockDigitState();
}

class _ClockDigitState extends State<ClockDigit> with TickerProviderStateMixin {
  AnimationController _loaderAnimationController;
  Animation<double> _loaderAnimation;
  AnimationController _bubbleAnimationController;
  Animation<double> _bubbleAnimation;

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
        Container(
          height: ANIMATION_CONTAINER_HEIGHT,
          width: ANIMATION_CONTAINER_WIDTH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: widget.color.withOpacity(0.2),
          ),
          margin: EdgeInsets.all(4),
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
              AnimatedBuilder(
                animation: _bubbleAnimation,
                builder: (_, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: BubblePainter(
                      progress: _bubbleAnimation.value,
                      color: widget.color,
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: widget.color,
                  radius: 5.0,
                ),
              ),
            ],
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
    _bubbleAnimationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    _loaderAnimation = Tween(begin: widget.digit.initialProgress, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: _loaderAnimationController,
          curve: Curves.linear,
        ),
      );
    _bubbleAnimation = Tween(begin: 0.0, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: _bubbleAnimationController,
          curve: Curves.linear,
        ),
      );

    _loaderAnimationController.forward();
    _bubbleAnimationController.forward();
  }
}

