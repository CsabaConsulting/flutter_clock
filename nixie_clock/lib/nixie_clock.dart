// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'hexagon_painter.dart';
import 'nixie_tube.dart';
import 'vfd_painter.dart';

enum _Element {
  background,
  nixieOn,
  nixieGlow,
  nixieOff,
  nixieGrid,
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

  Widget buildNixiePart(
      BuildContext context,
      Map<_Element, Color> colors,
      double nixieFontSize)
  {
    final timeFormat = widget.model.is24HourFormat ? 'HH:mm:ss' : 'hh:mm:ss';
    final timeString = DateFormat(timeFormat).format(_now);

    final nixieWidgetWidth = nixieFontSize / 1.6;
    final nixieColonWidth = nixieFontSize / 4;
    // Nixie Tube section Style
    final nixieOnStyle = TextStyle(
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
    final nixieOffStyle = TextStyle(
      color: colors[_Element.nixieOff],
      fontFamily: 'TTChocolates',
      fontSize: nixieFontSize,
    );

    final hexagonGridLinePaint = Paint()
      ..color = colors[_Element.vfdGrid]
      ..strokeWidth = 1
      ..isAntiAlias = true;

    final hexagonPainter = HexagonPainter(
      areaSize: Size(nixieWidgetWidth, nixieFontSize),
      side: nixieFontSize / 50,
      gridLinePaint: hexagonGridLinePaint,
    );

    final List<Widget> nixieCharacters = [];
    timeString.split('').forEach((character) =>
      nixieCharacters.add(
          NixieTubeWidget(
            character: character,
            width: character == ':' ? nixieColonWidth : nixieWidgetWidth,
            onStyle: nixieOnStyle,
            offStyle: nixieOffStyle,
            gridPainter: hexagonPainter,
          )
      )
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: nixieCharacters,
    );
  }

  Widget buildVFDPart(
      BuildContext context,
      Map<_Element, Color> colors,
      double nixieFontSize)
  {
    // Vacuum Fluorescent Display section Style
    final vfdWidth = nixieFontSize / 1.6 * 6;
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
      ..isAntiAlias = true;
    final vfdBackgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colors[_Element.vfdTextOff];
    final vfdGridBackgroundPainter = VFDPainter(
      characterSize: characterSize,
      characterMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdBackgroundGridLinePaint,
      backgroundPaint: vfdBackgroundPaint,
      sideMargins: 40,
    );

    final vfdForegroundGridLinePaint = Paint()
      ..color = colors[_Element.vfdGrid]
      ..strokeWidth = 1
      ..isAntiAlias = true;
    final vfdGridForegroundPainter = VFDPainter(
      characterSize: characterSize,
      characterMargin: pixelSize,
      pixelSize: pixelSize,
      gridLinePaint: vfdForegroundGridLinePaint,
      backgroundPaint: null,
      sideMargins: 40,
    );

    return Container(
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
          child: SizedBox(
            width: vfdWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final mediaSize = MediaQuery.of(context).size;
    final nixieFontSize = min(mediaSize.height / 3, mediaSize.width / 4.5);

    return Container(
      color: colors[_Element.background],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildNixiePart(context, colors, nixieFontSize),
          buildVFDPart(context, colors, nixieFontSize),
        ],
      ),
    );
  }
}
