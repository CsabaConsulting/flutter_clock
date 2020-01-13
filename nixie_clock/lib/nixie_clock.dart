// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'color_configuration.dart';
import 'nixie_background_painter.dart';
import 'nixie_foreground_painter.dart';
import 'nixie_tube.dart';
import 'vfd_painter.dart';

/// Nixie + VFD retro clock.
class NixieClock extends StatefulWidget {
  const NixieClock(this.model);

  final ClockModel model;

  @override
  _NixieClockState createState() => _NixieClockState();
}

class _NixieClockState extends State<NixieClock> {
  DateTime _now = DateTime.now();
  var _temperature = '';
  var _weather = '';
  var _location = '';
  DateFormat dateFormat;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(NixieClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = '${widget.model.temperatureString}';
      _weather = '${widget.model.weatherString}, ' +
          '(${widget.model.low} - ${widget.model.highString})';
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  Widget buildNixiePart(BuildContext context, Map<ColorSelector, Color> colorSet,
      double nixieFontSize) {
    final timeFormat = widget.model.is24HourFormat ? 'HH:mm:ss' : 'hh:mm:ss';
    final timeString = DateFormat(timeFormat).format(_now);
    // Nixie Tube section Style
    final nixieOnStyle = TextStyle(
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
    final nixieOffStyle = TextStyle(
      color: colorSet[ColorSelector.nixieOff],
      fontFamily: 'RobotoThin',
      fontSize: nixieFontSize,
      fontWeight: FontWeight.w100,
    );

    var backgroundGradient = RadialGradient(
      center: const Alignment(0.06, 0.07),
      radius: 0.9,
      colors: [
        colorSet[ColorSelector.nixieBgGlow1],
        colorSet[ColorSelector.nixieBgGlow2],
        colorSet[ColorSelector.nixieBgGlow3],
      ],
      stops: [0.0, 0.5, 1.0],
    );
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
    final nixieForegroundPainter = NixieForegroundPainter(
      side: nixieFontSize / 40,
      gridLinePaint: hexagonGridLinePaint,
      tubePaint: tubePaint,
      legPaint: legPaint,
    );

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
    final nixieBackgroundPainter = NixieBackgroundPainter(
      side: nixieFontSize / 40,
      partFillPaint: nixiePartFillPaint,
      partStrokePaint: nixiePartStrokePaint,
      partStrokePaintThick: nixiePartStrokePaintThick,
      nixieOffPaint: nixieOffPaint,
    );

    final List<Widget> nixieCharacters = [];
    timeString
        .split('')
        .forEach((character) => nixieCharacters.add(NixieTubeWidget(
              character: character,
              onStyle: nixieOnStyle,
              offStyle: nixieOffStyle,
              foregroundPainter: nixieForegroundPainter,
              backgroundPainter: nixieBackgroundPainter,
              backgroundGradient: backgroundGradient,
            )));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: nixieCharacters,
    );
  }

  Widget buildVFDPart(BuildContext context, Map<ColorSelector, Color> colorSet,
      double nixieFontSize) {
    // Vacuum Fluorescent Display section Style
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

    final vfdBackgroundGridLinePaint = Paint()
      ..color = colorSet[ColorSelector.vfdBackground]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = false;
    final vfdBackgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colorSet[ColorSelector.vfdTextOff];
    final vfdGridBackgroundPainter = VFDPainter(
      charSize: charSize,
      charMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdBackgroundGridLinePaint,
      backgroundPaint: vfdBackgroundPaint,
      sideMargins: sideMargin,
    );

    final vfdForegroundGridLinePaint = Paint()
      ..color = colorSet[ColorSelector.vfdGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = false;
    final vfdGridForegroundPainter = VFDPainter(
      charSize: charSize,
      charMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdForegroundGridLinePaint,
      backgroundPaint: null,
      sideMargins: sideMargin,
    );

    final currentLocale = Localizations.localeOf(context).toString();
    final dateString = DateFormat.yMMMd(currentLocale).format(_now);
    final firstLine = '$dateString, $_temperature';

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
        painter: vfdGridBackgroundPainter,
        foregroundPainter: vfdGridForegroundPainter,
        child: DefaultTextStyle(
          style: vfdStyle,
          child: SizedBox(
            width: vfdWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(firstLine),
                Text(_weather),
                Text(_location),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorSet = Theme.of(context).brightness == Brightness.light
        ? lightTheme
        : darkTheme;

    final mediaSize = MediaQuery.of(context).size;

    // print('size: $mediaSize');

    var widthDivider = 5.0;
    if (mediaSize.width < 700) {
      widthDivider = 5.5;
    } else if (mediaSize.width < 1000) {
      widthDivider = 5.1;
    } else if (mediaSize.width < 1300) {
      widthDivider = 5.05;
    } else if (mediaSize.width < 1600) {
      widthDivider = 4.9;
    }
    final nixieFontSize = min(mediaSize.height / 3.5, mediaSize.width / widthDivider);

    return Container(
      color: colorSet[ColorSelector.background],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildNixiePart(context, colorSet, nixieFontSize),
          buildVFDPart(context, colorSet, nixieFontSize),
        ],
      ),
    );
  }
}
