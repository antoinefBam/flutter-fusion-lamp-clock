import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/lavaTime.dart';

const ANIMATION_CONTAINER_HEIGHT = 300.0;
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
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(ClockDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _init();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        AnimatedContainer(
          duration: Duration(milliseconds: 475),
          curve: Curves.ease,
          height: ANIMATION_CONTAINER_HEIGHT,
          width: ANIMATION_CONTAINER_WIDTH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: widget.color.withOpacity(0.2),
          ),
          margin: EdgeInsets.all(4),
          child: Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: DigitPainter(
                    progress: _animation.value,
                    color: widget.color,
                    backgroundColor: widget.backgroundColor,
                    clearCanvas: _animation.isCompleted,
                  ),
                );
              },
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
    _animationController = AnimationController(
      duration: widget.digit.timeLeftBeforeDigitUpdate,
      vsync: this,
    );

    _animation = Tween(begin: widget.digit.initialProgress, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.linear,
        ),
      );

    _animationController.forward();
  }
}

class DigitPainter extends CustomPainter {
  DigitPainter({
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
    canvas.drawRect(
      Rect.fromPoints(
        const Offset(ANIMATION_CONTAINER_WIDTH, ANIMATION_CONTAINER_HEIGHT),
        Offset(0, (1.0 - progress) * ANIMATION_CONTAINER_HEIGHT),
      ),
      Paint()
        ..color = clearCanvas ? backgroundColor : color
    );
  }

  @override
  bool shouldRepaint(DigitPainter oldDelegate) => oldDelegate.progress != progress;
}
