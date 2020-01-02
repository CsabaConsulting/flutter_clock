import 'package:flutter/material.dart';


class NixieTubeWidget extends StatelessWidget {
  NixieTubeWidget({
    this.character,
    this.onStyle,
    this.offStyle,
    this.foregroundPainter,
    this.backgroundGradient,
  });
  /// Digit to display
  final String character;
  final TextStyle onStyle;
  final TextStyle offStyle;
  final CustomPainter foregroundPainter;
  final RadialGradient backgroundGradient;
  final digitOrder = ':6574839201'.split('');

  Widget buildDigits(BuildContext context) {
    final List<Widget> nixieDigits = [];
    digitOrder.where((digit) => digit != character).forEach((digit) =>
      nixieDigits.add(
        Center(
          child: DefaultTextStyle(
            style: offStyle,
            child: Text(digit),
          )
        )
      )
    );
    nixieDigits.add(
      Center(
        child: DefaultTextStyle(
          style: onStyle,
          child: Text(character),
        )
      )
    );

    return Stack(children: nixieDigits);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
      decoration: BoxDecoration(
        gradient: backgroundGradient,
      ),
      child: CustomPaint(
        foregroundPainter: foregroundPainter,
        child: buildDigits(context),
      ),
    );
  }
}
