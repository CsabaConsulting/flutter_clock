import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../color_configuration.dart';
import '../nixie_vfd_clock.dart';
import 'vfd_painter.dart';

class VFDAssembly extends StatelessWidget {
  VFDAssembly({
    this.colorSet,
    this.nixieFontSize,
  });

  final Map<ColorSelector, Color> colorSet;
  final double nixieFontSize;

  VFDPainter getBackgroundPainter(
      Size charSize, Size pixelSize, double sideMargin) {
    final vfdBackgroundGridLinePaint = Paint()
      ..color = colorSet[ColorSelector.vfdBackground]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = false;

    final vfdBackgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colorSet[ColorSelector.vfdTextOff];

    return VFDPainter(
      charSize: charSize,
      charMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdBackgroundGridLinePaint,
      backgroundPaint: vfdBackgroundPaint,
      sideMargins: sideMargin,
    );
  }

  VFDPainter getForegroundPainter(
      Size charSize, Size pixelSize, double sideMargin) {
    final vfdForegroundGridLinePaint = Paint()
      ..color = colorSet[ColorSelector.vfdGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = false;

    return VFDPainter(
      charSize: charSize,
      charMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdForegroundGridLinePaint,
      backgroundPaint: null,
      sideMargins: sideMargin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vfdFontSize = nixieFontSize / 3.0;
    final vfdStyle = TextStyle(
      color: colorSet[ColorSelector.vfdTextOn],
      fontFamily: 'VT323',
      fontSize: vfdFontSize,
    );
    final charSize = Size(vfdFontSize / 2.5, vfdFontSize);
    final vfdWidthUnadjusted = nixieFontSize * 5.0;
    final vfdWidth = vfdWidthUnadjusted - vfdWidthUnadjusted % charSize.width;
    final pixelSize = Size(charSize.width / 5, charSize.height / 10);
    final sideMargin = charSize.width / 4.0;

    final ClockState state = NixieVFDClock.of(context);
    final currentLocale = Localizations.localeOf(context).toString();
    final dateString = DateFormat.yMMMd(currentLocale).format(state.rightNow);
    final firstLine = '$dateString, ${state.temperature}';

    return Container(
      padding: EdgeInsets.fromLTRB(
        sideMargin,
        charSize.width / 4.0,
        sideMargin,
        charSize.width / 2.0,
      ),
      decoration: BoxDecoration(
        color: colorSet[ColorSelector.vfdBackground],
        borderRadius: BorderRadius.all(
          Radius.circular(charSize.width / 2),
        ),
      ),
      child: CustomPaint(
        painter: getBackgroundPainter(charSize, pixelSize, sideMargin),
        foregroundPainter: getForegroundPainter(charSize, pixelSize, sideMargin),
        child: DefaultTextStyle(
          style: vfdStyle,
          child: SizedBox(
            width: vfdWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(firstLine),
                Text(state.weather),
                Text(state.location),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
