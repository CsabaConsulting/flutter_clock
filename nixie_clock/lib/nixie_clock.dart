// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

import 'hexagon_painter.dart';
import 'nixie_tube.dart';
import 'vfd_painter.dart';

enum _Element {
  background,
  nixieOn,
  nixieGlow,
  nixieGrid,
  vfdTextOn,
  vfdTextGlow,
  vfdTextOff,
  vfdBackground,
  vfdGrid,
}

final _lightTheme = {
  _Element.background: Color(0xFFEFEEEA),
  _Element.nixieOn: Color(0xFFFCD905),
  _Element.nixieGlow: Color(0xFFE5010E),
  _Element.vfdTextOn: Color(0xFFBBFEFF),
  _Element.vfdTextGlow: Color(0xFFCBFFFF),
  _Element.vfdTextOff: Color(0xFF364852),
  _Element.vfdBackground: Color(0xFF1A2E39),
  _Element.vfdGrid: Color(0xBB1A2E39),
};

final _darkTheme = {
  _Element.background: Color(0xFF0F0000),
  _Element.nixieOn: Color(0xFFFCD905),
  _Element.nixieGlow: Color(0xFFE5010E),
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
  var _temperatureAndCondition = '';
  var _temperatureRange = '';
  var _location = '';
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
      _temperatureAndCondition =
        '${widget.model.temperatureString}, ${widget.model.weatherString}';
      _temperatureRange =
        '(Low ${widget.model.low} - High ${widget.model.highString})';
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final timeFormat = widget.model.is24HourFormat ? 'HH:mm:ss' : 'hh:mm:ss';
    final timeFull = DateFormat(timeFormat).format(_now);
    final timeParts = timeFull.split(':');
    final hours = timeParts[0];
    final hourDigit1 = hours.length > 1 ? hours[0] : '';
    final hourDigit2 = hours[hours.length > 1 ? 1 : 0];
    final minutes = timeParts[1];
    final minuteDigit1 = minutes[0];
    final minuteDigit2 = minutes[1];
    final seconds = timeParts[2];
    final secondDigit1 = seconds[0];
    final secondDigit2 = seconds[1];

    final mediaSize = MediaQuery.of(context).size;
    final nixieFontSize = min(mediaSize.height / 3, mediaSize.width / 4.5);
    final nixieWidgetWidth = nixieFontSize / 1.6;
    final nixieColonWidth = nixieFontSize / 4;
    // Nixie Tube section Style
    final nixieStyle = TextStyle(
      color: colors[_Element.nixieOn],
      fontFamily: 'TTChocolates',
      fontSize: nixieFontSize,
      shadows: [
        Shadow(
          blurRadius: 20,
          color: colors[_Element.nixieGlow],
          offset: Offset(0, 0),
        ),
      ],
    );
    // Vacuum Fluorescent Display section Style
    final vfdFontSize = nixieFontSize / 2.5;
    final vfdStyle = TextStyle(
      color: colors[_Element.vfdTextOn],
      fontFamily: 'VT323',
      fontSize: vfdFontSize,
    );
    final characterSize = Size(vfdFontSize / 2.5, vfdFontSize);
    final pixelSize = Size(characterSize.width / 10, characterSize.height / 10);

    final vfdBackgroundGridLinePaint = Paint()
      ..color = colors[_Element.vfdBackground]
      ..strokeWidth = 1
      ..isAntiAlias = false;
    final vfdBackgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colors[_Element.vfdTextOff];
    final vfdGridBackgroundPainter = VFDPainter(
      characterSize: characterSize,
      characterMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdBackgroundGridLinePaint,
      backgroundPaint: vfdBackgroundPaint,
    );

    final vfdForegroundGridLinePaint = Paint()
      ..color = colors[_Element.vfdGrid]
      ..strokeWidth = 1
      ..isAntiAlias = false;
    final vfdGridForegroundPainter = VFDPainter(
      characterSize: characterSize,
      characterMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdForegroundGridLinePaint,
      backgroundPaint: null,
    );

    final hexagonPainter = HexagonPainter(
      areaSize: characterSize,
      side: 10,
      gridLinePaint: vfdForegroundGridLinePaint,
    );

    return Container(
      color: colors[_Element.background],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NixieTubeWidget(
                digit: hourDigit1,
                width: nixieWidgetWidth,
                style: nixieStyle,
                gridPainter: hexagonPainter,
              ),
              NixieTubeWidget(
                digit: hourDigit2,
                width: nixieWidgetWidth,
                style: nixieStyle,
                gridPainter: hexagonPainter,
              ),
              NixieTubeWidget(
                digit: ':',
                width: nixieColonWidth,
                style: nixieStyle,
                gridPainter: hexagonPainter,
              ),
              NixieTubeWidget(
                digit: minuteDigit1,
                width: nixieWidgetWidth,
                style: nixieStyle,
                gridPainter: hexagonPainter,
              ),
              NixieTubeWidget(
                digit: minuteDigit2,
                width: nixieWidgetWidth,
                style: nixieStyle,
                gridPainter: hexagonPainter,
              ),
              NixieTubeWidget(
                digit: ':',
                width: nixieColonWidth,
                style: nixieStyle,
                gridPainter: hexagonPainter,
              ),
              NixieTubeWidget(
                digit: secondDigit1,
                width: nixieWidgetWidth,
                style: nixieStyle,
                gridPainter: hexagonPainter,
              ),
              NixieTubeWidget(
                digit: secondDigit2,
                width: nixieWidgetWidth,
                style: nixieStyle,
                gridPainter: hexagonPainter,
              ),
            ],
          ),
          Container(
            padding: new EdgeInsets.all(20.0),
            decoration: new BoxDecoration(
              color: colors[_Element.vfdBackground],
              borderRadius: new BorderRadius.all(new Radius.circular(40.0)),
            ),
            child: CustomPaint(
              painter: vfdGridBackgroundPainter,
              foregroundPainter: vfdGridForegroundPainter,
              child: DefaultTextStyle(
                style: vfdStyle,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_temperatureAndCondition),
                    Text(_temperatureRange),
                    Text(_location),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
