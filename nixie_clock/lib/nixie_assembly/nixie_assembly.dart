import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../color_configuration.dart';
import '../nixie_vfd_clock.dart';
import 'nixie_background_painter.dart';
import 'nixie_foreground_painter.dart';
import 'nixie_tube.dart';

class NixieAssembly extends StatelessWidget {
  NixieAssembly({
    this.colorSet,
    this.nixieFontSize,
  });

  final Map<ColorSelector, Color> colorSet;
  final double nixieFontSize;

  TextStyle getOnStyle() {
    return TextStyle(
      color: colorSet[ColorSelector.nixieOn],
      fontFamily: 'RobotoThin',
      fontSize: nixieFontSize,
      fontWeight: FontWeight.w100,
      shadows: [
        Shadow(
          blurRadius: 20.0,
          color: colorSet[ColorSelector.nixieGlow],
          offset: Offset(0, 0),
        ),
      ],
    );
  }

  RadialGradient getBackgroundGradient() {
    return RadialGradient(
      center: const Alignment(0.06, 0.07),
      radius: 0.9,
      colors: [
        colorSet[ColorSelector.nixieBgGlow1],
        colorSet[ColorSelector.nixieBgGlow2],
        colorSet[ColorSelector.nixieBgGlow3],
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }

  TextStyle getOffStyle() {
    return TextStyle(
      color: colorSet[ColorSelector.nixieOff],
      fontFamily: 'RobotoThin',
      fontSize: nixieFontSize,
      fontWeight: FontWeight.w100,
    );
  }

  NixieForegroundPainter getForegroundPainter(
      double thinnerStroke, double thickerStroke) {
    final hexagonGridLinePaint = Paint()
      ..color = colorSet[ColorSelector.nixieGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    final tubePaint = Paint()
      ..color = colorSet[ColorSelector.nixieGlass]
      ..style = PaintingStyle.stroke
      ..strokeWidth = thinnerStroke
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final legPaint = Paint()
      ..color = colorSet[ColorSelector.nixieGlass]
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickerStroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    return NixieForegroundPainter(
      side: nixieFontSize / 40.0,
      gridLinePaint: hexagonGridLinePaint,
      tubePaint: tubePaint,
      legPaint: legPaint,
    );
  }

  NixieBackgroundPainter getBackgroundPainter(
      double thinnerStroke, double thickerStroke) {
    final nixiePartFillPaint = Paint()
      ..color = colorSet[ColorSelector.nixieGrid]
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final nixiePartStrokePaint = Paint()
      ..color = colorSet[ColorSelector.nixieGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = thinnerStroke
      ..isAntiAlias = true;

    final nixiePartStrokePaintThick = Paint()
      ..color = colorSet[ColorSelector.nixieGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickerStroke
      ..isAntiAlias = true;

    final nixieOffPaint = Paint()
      ..color = colorSet[ColorSelector.nixieOff]
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickerStroke
      ..isAntiAlias = true;

    return NixieBackgroundPainter(
      side: nixieFontSize / 40.0,
      partFillPaint: nixiePartFillPaint,
      partStrokePaint: nixiePartStrokePaint,
      partStrokePaintThick: nixiePartStrokePaintThick,
      nixieOffPaint: nixieOffPaint,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ClockState state = NixieVFDClock.of(context);
    final timeFormat = state.model.is24HourFormat ? 'HH:mm:ss' : 'hh:mm:ss';
    final timeString = DateFormat(timeFormat).format(state.rightNow);

    final mediaWidth = MediaQuery.of(context).size.width;
    final thinnerStroke = mediaWidth < 1000 ? 1.0 : 2.0;
    final thickerStroke = mediaWidth < 1000
        ? 1.0
        : (mediaWidth < 1300 ? 2.0 : mediaWidth < 1600 ? 3 : 4.0);

    final List<Widget> nixieCharacters = [];
    timeString.split('').forEach((character) => nixieCharacters.add(
      NixieTube(
        character: character,
        onStyle: getOnStyle(),
        offStyle: getOffStyle(),
        foregroundPainter: getForegroundPainter(thinnerStroke, thickerStroke),
        backgroundPainter: getBackgroundPainter(thinnerStroke, thickerStroke),
        backgroundGradient: getBackgroundGradient(),
      )
    ));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: nixieCharacters,
    );
  }
}
