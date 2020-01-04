import 'package:flutter/material.dart';

const DIGIT_HEIGHT = 50.0;
const DIGIT_WIDTH = 50.0;
const FONT_SIZE = 50.0;

class Separator extends StatelessWidget {
  const Separator({
    Key key,
    @required  this.symbol,
  }) :
    assert(symbol != null,'symbol is required'),
    assert(symbol.length == 1,'symbol has one character'),
    super(key: key);
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DIGIT_WIDTH,
      height: DIGIT_HEIGHT,
      alignment: Alignment.center,
      child: Text(
        symbol,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'CrimesceneAfterimage',
          fontSize: FONT_SIZE,
        ),
      ),
    );
  }
}

