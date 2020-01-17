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
          blurRadius: 20,
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

  NixieForegroundPainter getForegroundPainter() {
    final hexagonGridLinePaint = Paint()
      ..color = colorSet[ColorSelector.nixieGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true;

    final tubePaint = Paint()
      ..color = colorSet[ColorSelector.nixieGlass]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final legPaint = Paint()
      ..color = colorSet[ColorSelector.nixieGlass]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    return NixieForegroundPainter(
      side: nixieFontSize / 40,
      gridLinePaint: hexagonGridLinePaint,
      tubePaint: tubePaint,
      legPaint: legPaint,
    );
  }

  NixieBackgroundPainter getBackgroundPainter() {
    final nixiePartFillPaint = Paint()
      ..color = colorSet[ColorSelector.nixieGrid]
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final nixiePartStrokePaint = Paint()
      ..color = colorSet[ColorSelector.nixieGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..isAntiAlias = true;

    final nixiePartStrokePaintThick = Paint()
      ..color = colorSet[ColorSelector.nixieGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..isAntiAlias = true;

    final nixieOffPaint = Paint()
      ..color = colorSet[ColorSelector.nixieOff]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..isAntiAlias = true;

    return NixieBackgroundPainter(
      side: nixieFontSize / 40,
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

    final List<Widget> nixieCharacters = [];
    timeString
        .split('')
        .forEach((character) => nixieCharacters.add(NixieTube(
      character: character,
      onStyle: getOnStyle(),
      offStyle: getOffStyle(),
      foregroundPainter: getForegroundPainter(),
      backgroundPainter: getBackgroundPainter(),
      backgroundGradient: getBackgroundGradient(),
    )));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: nixieCharacters,
    );
  }
}
