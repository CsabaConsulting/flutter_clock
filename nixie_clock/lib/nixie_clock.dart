// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'nixie_background_painter.dart';
import 'nixie_foreground_painter.dart';
import 'nixie_tube.dart';
import 'vfd_painter.dart';

enum _Element {
  background,
  nixieOn,
  nixieGlow,
  nixieOff,
  nixieGrid,
  nixieBgGlow1,
  nixieBgGlow2,
  nixieBgGlow3,
  nixieGlass,
  vfdTextOn,
  vfdTextGlow,
  vfdTextOff,
  vfdBackground,
  vfdGrid,
}

final _lightTheme = {
  _Element.background: Color(0xFFEFEEEA),
  _Element.nixieOn: Color(0xDDFFFF8C),
  _Element.nixieGlow: Color(0xDDFEF06B),
  _Element.nixieOff: Color(0xDDC58A68),
  _Element.nixieGrid: Color(0xFF364852),
  _Element.nixieBgGlow1: Color(0x99FFAA0F),
  _Element.nixieBgGlow2: Color(0x99FA611B),
  _Element.nixieBgGlow3: Color(0x00FFAA0F),
  _Element.nixieGlass: Color(0xFF3D2021),
  _Element.vfdTextOn: Color(0xFFBBFEFF),
  _Element.vfdTextGlow: Color(0xFFCBFFFF),
  _Element.vfdTextOff: Color(0xFF364852),
  _Element.vfdBackground: Color(0xFF1A2E39),
  _Element.vfdGrid: Color(0xBB1A2E39),
};

final _darkTheme = {
  _Element.background: Color(0xFF0F0000),
  _Element.nixieOn: Color(0xDDFFFF8C),
  _Element.nixieGlow: Color(0xDDFEF06B),
  _Element.nixieOff: Color(0xDDC58A68),
  _Element.nixieGrid: Color(0xFF364852),
  _Element.nixieBgGlow1: Color(0x99FFAA0F),
  _Element.nixieBgGlow2: Color(0x99FA611B),
  _Element.nixieBgGlow3: Color(0x00FFAA0F),
  _Element.nixieGlass: Color(0xFF3D2021),
  _Element.vfdTextOn: Color(0xFFBBFEFF),
  _Element.vfdTextGlow: Color(0xFFCBFFFF),
  _Element.vfdTextOff: Color(0xFF364852),
  _Element.vfdBackground: Color(0xFF1A2E39),
  _Element.vfdGrid: Color(0xBB1A2E39),
};

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

  Widget buildNixiePart(BuildContext context, Map<_Element, Color> colorSet,
      double nixieFontSize) {
    final timeFormat = widget.model.is24HourFormat ? 'HH:mm:ss' : 'hh:mm:ss';
    final timeString = DateFormat(timeFormat).format(_now);
    // Nixie Tube section Style
    final nixieOnStyle = TextStyle(
      color: colorSet[_Element.nixieOn],
      fontFamily: 'RobotoThin',
      fontSize: nixieFontSize,
      fontWeight: FontWeight.w100,
      shadows: [
        Shadow(
          blurRadius: 20,
          color: colorSet[_Element.nixieGlow],
          offset: Offset(0, 0),
        ),
      ],
    );
    final nixieOffStyle = TextStyle(
      color: colorSet[_Element.nixieOff],
      fontFamily: 'RobotoThin',
      fontSize: nixieFontSize,
      fontWeight: FontWeight.w100,
    );

    var backgroundGradient = RadialGradient(
      center: const Alignment(0.06, 0.07),
      radius: 0.9,
      colors: [
        colorSet[_Element.nixieBgGlow1],
        colorSet[_Element.nixieBgGlow2],
        colorSet[_Element.nixieBgGlow3],
      ],
      stops: [0.0, 0.5, 1.0],
    );
    final hexagonGridLinePaint = Paint()
      ..color = colorSet[_Element.nixieGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true;
    final tubePaint = Paint()
      ..color = colorSet[_Element.nixieGlass]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..isAntiAlias = true;
    final nixieForegroundPainter = NixieForegroundPainter(
      side: nixieFontSize / 40,
      gridLinePaint: hexagonGridLinePaint,
      tubePaint: tubePaint,
    );

    final nixiePartFillPaint = Paint()
      ..color = colorSet[_Element.nixieGrid]
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final nixiePartStrokePaint = Paint()
      ..color = colorSet[_Element.nixieGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..isAntiAlias = true;
    final nixiePartStrokePaintThick = Paint()
      ..color = colorSet[_Element.nixieGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..isAntiAlias = true;
    final nixieBackgroundPainter = NixieBackgroundPainter(
      side: nixieFontSize / 40,
      partFillPaint: nixiePartFillPaint,
      partStrokePaint: nixiePartStrokePaint,
      partStrokePaintThick: nixiePartStrokePaintThick,
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

  Widget buildVFDPart(BuildContext context, Map<_Element, Color> colorSet,
      double nixieFontSize) {
    // Vacuum Fluorescent Display section Style
    final vfdFontSize = nixieFontSize / 3;
    final vfdStyle = TextStyle(
      color: colorSet[_Element.vfdTextOn],
      fontFamily: 'VT323',
      fontSize: vfdFontSize,
    );
    final charSize = Size(vfdFontSize / 2.5, vfdFontSize);
    final vfdWidthUnadjusted = nixieFontSize * 6;
    final vfdWidth = vfdWidthUnadjusted - vfdWidthUnadjusted % charSize.width;
    final pixelSize = Size(charSize.width / 10, charSize.height / 10);

    final vfdBackgroundGridLinePaint = Paint()
      ..color = colorSet[_Element.vfdBackground]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = false;
    final vfdBackgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colorSet[_Element.vfdTextOff];
    final vfdGridBackgroundPainter = VFDPainter(
      charSize: charSize,
      charMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdBackgroundGridLinePaint,
      backgroundPaint: vfdBackgroundPaint,
      sideMargins: 40,
    );

    final vfdForegroundGridLinePaint = Paint()
      ..color = colorSet[_Element.vfdGrid]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = false;
    final vfdGridForegroundPainter = VFDPainter(
      charSize: charSize,
      charMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdForegroundGridLinePaint,
      backgroundPaint: null,
      sideMargins: 40,
    );

    final currentLocale = Localizations.localeOf(context).toString();
    final dateString = DateFormat.yMMMd(currentLocale).format(_now);
    final firstLine = '$dateString, $_temperature';

    return Container(
      padding: EdgeInsets.fromLTRB(
        charSize.width,
        charSize.width / 4,
        charSize.width / 2,
        charSize.width / 2,
      ),
      decoration: BoxDecoration(
        color: colorSet[_Element.vfdBackground],
        borderRadius: BorderRadius.all(
          Radius.circular(charSize.width / 2),
        ),
      ),
      child: CustomPaint(
        painter: vfdGridBackgroundPainter,
        foregroundPainter: vfdGridForegroundPainter,
        child: SizedBox(
          width: vfdWidth,
          child: DefaultTextStyle(
            style: vfdStyle,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
        ? _lightTheme
        : _darkTheme;

    final mediaSize = MediaQuery.of(context).size;
    final nixieFontSize = min(mediaSize.height / 3.5, mediaSize.width / 5.1);

    return Container(
      color: colorSet[_Element.background],
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
