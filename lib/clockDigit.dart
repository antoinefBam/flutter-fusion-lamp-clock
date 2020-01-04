import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/lavaTime.dart';

const DIGIT_HEIGHT = 50.0;
const DIGIT_WIDTH = 50.0;
const FONT_SIZE = 50.0;

class ClockDigit extends StatefulWidget {
  const ClockDigit({
    Key key,
    @required this.digit,
    this.color = Colors.black,
  }) : 
  assert(digit != null, 'digit is required'),
  super(key: key);

  final Digit digit;
  final Color color;

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
    return Container(
      width: DIGIT_WIDTH,
      height: DIGIT_HEIGHT,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _animation,
            builder: (_, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: DigitPainter(
                  progress: _animation.value,
                  color: widget.color,
                  clearCanvas: _animation.isCompleted,
                ),
              );
            },
          ),
          Text(
            widget.digit.value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'CrimesceneAfterimage',
              fontSize: FONT_SIZE,
            ),
          ),
        ],
      ),
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
    this.clearCanvas = false,
  }) :
    assert(progress != null, 'progress is required'),
    assert(progress >= 0.0 && progress <= 1.0, 'progress is between 0 and 1'),
    assert(color != null, 'color is required');

  final double progress;
  final Color color;
  final bool clearCanvas;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      const Offset(DIGIT_WIDTH / 2, DIGIT_HEIGHT),
      Offset(DIGIT_WIDTH / 2, (1.0 - progress) * DIGIT_HEIGHT),
      Paint()
        ..color = clearCanvas ? Colors.white : color
        ..strokeWidth = FONT_SIZE,
    );
  }

  @override
  bool shouldRepaint(DigitPainter oldDelegate) => oldDelegate.progress != progress;
}
