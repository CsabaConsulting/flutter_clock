import 'package:flutter/material.dart';


class NixieTubeWidget extends StatelessWidget {
  NixieTubeWidget({this.digit, this.width, this.style, this.gridPainter});
  /// Digit to display
  final String digit;
  final double width;
  final TextStyle style;
  final CustomPainter gridPainter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Center(
        child: Stack(
          children: <Widget>[
            DefaultTextStyle(
              style: style,
              child: Text(digit == '1' ? 'I' : digit)
            ),
            CustomPaint(
              painter: gridPainter,
            ),
          ],
        ),
      ),
    );
  }
}
