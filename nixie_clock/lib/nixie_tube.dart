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
    final digitOrder = '6574839201';
    final List<Widget> nixieDigits = [];
    digitOrder.split('').forEach((digit) =>
      nixieDigits.add(
        Center(
          child: DefaultTextStyle(
            style: character == digit ? onStyle : offStyle,
            child: Text(digit == '1' ? 'I' : digit),
          )
        )
      )
    );

    return Stack(
      children: nixieDigits,
//        CustomPaint(
//          foregroundPainter: gridPainter,
//        ),
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
