import 'package:flutter/material.dart';


class NixieTubeWidget extends StatelessWidget {
  NixieTubeWidget({
    this.character,
    this.width,
    this.onStyle,
    this.offStyle,
    this.gridPainter
  });
  /// Digit to display
  final String character;
  final double width;
  final TextStyle onStyle;
  final TextStyle offStyle;
  final CustomPainter gridPainter;

  Widget buildDigits(BuildContext context) {
    // final digitOrder = '6574839201';
    return Stack(
      children: <Widget>[
        Center(
          child: DefaultTextStyle(
            style: character == '6' ? onStyle : offStyle,
            child: Text('6'),
          )
        ),
        Center(
          child: DefaultTextStyle(
            style: character == '5' ? onStyle : offStyle,
            child: Text('5'),
          ),
        ),
        Center(
          child: DefaultTextStyle(
            style: character == '7' ? onStyle : offStyle,
            child: Text('7'),
          ),
        ),
        Center(
          child: DefaultTextStyle(
            style: character == '4' ? onStyle : offStyle,
            child: Text('4'),
          ),
        ),
        Center(
          child: DefaultTextStyle(
            style: character == '8' ? onStyle : offStyle,
            child: Text('8'),
          ),
        ),
        Center(
          child: DefaultTextStyle(
            style: character == '3' ? onStyle : offStyle,
            child: Text('3'),
          ),
        ),
        Center(
          child: DefaultTextStyle(
            style: character == '9' ? onStyle : offStyle,
            child: Text('9'),
          ),
        ),
        Center(
          child: DefaultTextStyle(
            style: character == '2' ? onStyle : offStyle,
            child: Text('2'),
          ),
        ),
        Center(
          child: DefaultTextStyle(
            style: character == '0' ? onStyle : offStyle,
            child: Text('0'),
          ),
        ),
        Center(
          child: DefaultTextStyle(
            style: character == '1' ? onStyle : offStyle,
            child: Text('I'),
          ),
        ),
//        CustomPaint(
//          foregroundPainter: gridPainter,
//        ),
      ],
    );
  }

  Widget buildOther(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
            child: DefaultTextStyle(
              style: onStyle,
              child: Text(character),
            )
        ),
//        CustomPaint(
//          foregroundPainter: gridPainter,
//        ),
      ],
    );
  }

  bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: isDigit(character, 0) ? buildDigits(context) : buildOther(context)
    );
  }
}
