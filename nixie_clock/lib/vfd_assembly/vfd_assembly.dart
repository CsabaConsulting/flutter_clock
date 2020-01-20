import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../color_configuration.dart';
import '../nixie_vfd_clock.dart';
import 'vfd_line.dart';
import 'vfd_painter.dart';

class VFDAssembly extends StatelessWidget {
  VFDAssembly({
    this.colorSet,
    this.nixieFontSize,
  });

  final Map<ColorSelector, Color> colorSet;
  final double nixieFontSize;

  VFDPainter getBackgroundPainter(Size charSize, Size pixelSize) {
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
    );
  }

  VFDPainter getForegroundPainter(Size charSize, Size pixelSize) {
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
    final maxChars = vfdWidthUnadjusted ~/ charSize.width;
    final pixelSize = Size(charSize.width / 5, charSize.height / 10);
    final sideMargin = charSize.width / 4.0;

    final ClockState state = NixieVFDClock.of(context);
    final currentLocale = Localizations.localeOf(context).toString();
    final dateString = DateFormat.yMMMd(currentLocale).format(state.rightNow);
    final firstLine = '$dateString, ${state.temperature}';

    final VFDPainter backgroundPainter = getBackgroundPainter(charSize, pixelSize);
    final VFDPainter foregroundPainter = getForegroundPainter(charSize, pixelSize);

    final List<String> lineStrings = [firstLine, state.weather, state.location];
    final List<Widget> vfdLines = [];
    lineStrings.forEach((line) => vfdLines.add(
      VFDLine(
        text: line,
        maxChars: maxChars,
        charSize: charSize,
        charMargin: pixelSize,
        pixelSize: pixelSize,
        backgroundPainter: backgroundPainter,
        foregroundPainter: foregroundPainter,
      )
    ));

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
        child: DefaultTextStyle(
          style: vfdStyle,
          child: Column(children: vfdLines),
        ),
      ),
    );
  }
}
