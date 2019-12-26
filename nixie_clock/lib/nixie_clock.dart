// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:hexagonal_grid/hexagonal_grid.dart';
import 'package:hexagonal_grid_widget/hex_grid_child.dart';
import 'package:hexagonal_grid_widget/hex_grid_context.dart';
import 'package:hexagonal_grid_widget/hex_grid_widget.dart';

enum _Element {
  background,
  nixieOn,
  nixieGlow,
  nixieGrid,
  vfdText,
  vfdBackground,
  vfdGrid,
}

final _lightTheme = {
  _Element.background: Color(0xFFEFEEEA),
  _Element.nixieOn: Color(0xFFFCD905),
  _Element.nixieGlow: Color(0xFFE5010E),
};

final _darkTheme = {
  _Element.background: Color(0xFF0F0000),
  _Element.nixieOn: Color(0xFFFCD905),
  _Element.nixieGlow: Color(0xFFE5010E),
};

/// Nixie + VFD retro clock.
///
/// You can do better than this!
class NixieClock extends StatefulWidget {
  const NixieClock(this.model);

  final ClockModel model;

  @override
  _NixieClockState createState() => _NixieClockState();
}

class _NixieClockState extends State<NixieClock> {
  DateTime _now = DateTime.now();
//  var _temperature = '';
//  var _temperatureRange = '';
//  var _condition = '';
//  var _location = '';
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
      // Cause the clock to rebuild when the model changes.
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
    final vfdFontSize = nixieFontSize / 4;
    final vfdStyle = TextStyle(
      color: colors[_Element.vfdText],
      fontFamily: 'VT323',
      fontSize: vfdFontSize,
    );

    return Container(
      color: colors[_Element.background],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DefaultTextStyle(
            style: nixieStyle,
            child: Row(
              children: <Widget>[
                Container(
                  width: nixieWidgetWidth,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Text(hourDigit1),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: nixieWidgetWidth,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Text(hourDigit2),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: nixieColonWidth,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Text(':'),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: nixieWidgetWidth,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Text(minuteDigit1),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: nixieWidgetWidth,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Text(minuteDigit2),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: nixieColonWidth,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Text(':'),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: nixieWidgetWidth,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Text(secondDigit1),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: nixieWidgetWidth,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Text(secondDigit2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          DefaultTextStyle(
            style: vfdStyle,
            child: Column(

            ),
          ),
        ],
      ),
    );
  }
}
