import 'package:flutter/material.dart';
import 'package:lava_lamp_clock/digit.dart';
import 'package:lava_lamp_clock/digitClipper.dart';
import 'package:lava_lamp_clock/painters/outline.painter.dart';
import 'package:lava_lamp_clock/painters/loader.painter.dart';
import 'package:path_drawing/path_drawing.dart';

class ClockSeparator extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  final Color outlineColor;
  
  const ClockSeparator({
    Key key,
    @required this.color,
    @required this.backgroundColor,
    @required this.outlineColor,
  }) : 
  assert(color != null, 'color is required'),
  assert(backgroundColor != null, 'backgroundColor is required'),
  assert(outlineColor != null, 'outlineColor is required'),
  super(key: key);

  @override
  Widget build(BuildContext context) {
    final separatorPath = parseSvgPathData(
      'M16.2104 31.976C11.9544 31.976 8.23038 30.456 5.03838 27.416C1.99838 24.224 0.478375 20.5 0.478375 16.244C0.478375 11.836 1.99838 8.11199 5.03838 5.07199C8.23038 1.87999 11.9544 0.283988 16.2104 0.283988C20.6184 0.283988 24.3424 1.87999 27.3824 5.07199C30.4224 8.11199 31.9424 11.836 31.9424 16.244C31.9424 20.5 30.4224 24.224 27.3824 27.416C24.3424 30.456 20.6184 31.976 16.2104 31.976ZM18.7184 128.648C14.4624 128.648 10.7384 127.128 7.54638 124.088C4.50638 120.896 2.98638 117.172 2.98638 112.916C2.98638 108.508 4.50638 104.784 7.54638 101.744C10.7384 98.552 14.4624 96.956 18.7184 96.956C23.1264 96.956 26.8504 98.552 29.8904 101.744C32.9304 104.784 34.4504 108.508 34.4504 112.916C34.4504 117.172 32.9304 120.896 29.8904 124.088C26.8504 127.128 23.1264 128.648 18.7184 128.648Z'
    );
    final separartorViewBox = ViewBox(35, 129);

    return Center(
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: DigitClipper(separatorPath),
            child: Container(
              height: separartorViewBox.height,
              width: separartorViewBox.width,
              color: color.withOpacity(0.2),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: LoaderPainter(
                      progress: 1.0,
                      liquidSurface: 0.0,
                      color: color,
                      backgroundColor: backgroundColor,
                      viewBox: separartorViewBox,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: separartorViewBox.height,
              width: separartorViewBox.width,
            child: CustomPaint(
              size: Size.infinite,
              painter: OutlinePainter(
                path: separatorPath,
                color: outlineColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}