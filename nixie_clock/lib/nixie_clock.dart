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
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFFEFEEEA),
  _Element.text: Color(0xFFFCD905),
  _Element.shadow: Color(0xFFE5010E),
};

final _darkTheme = {
  _Element.background: Color(0xFF0F0000),
  _Element.text: Color(0xFFFCD905),
  _Element.shadow: Color(0xFFE5010E),
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
  DateTime _dateTime = DateTime.now();
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
      _dateTime = DateTime.now();
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
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
    final timeFull = DateFormat(timeFormat).format(_dateTime);
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

    final fontSize = MediaQuery.of(context).size.width / 4.5;
    final offset = fontSize / 7;
    final widgetWidth = fontSize / 1.6;
    final colonWidth = fontSize / 4;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'TTChocolates',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 20,
          color: colors[_Element.shadow],
          offset: Offset(0, 0),
        ),
      ],
    );

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: offset,
                  top: offset,
                  child: Center(
                      child: Text(hourDigit1),
                  ),
              ),
              Positioned(
                  left: offset + widgetWidth,
                  top: offset,
                  child: Center(
                      child: Text(hourDigit2),
                  ),
              ),
              Positioned(
                  left: offset + 2 * widgetWidth,
                  top: offset,
                  child: Center(child: Text(':')),
              ),
              Positioned(
                  left: offset + 2 * widgetWidth + colonWidth,
                  top: offset,
                  child: Center(
                      child: Text(minuteDigit1),
                  ),
              ),
              Positioned(
                  left: offset + 3 * widgetWidth + colonWidth,
                  top: offset,
                  child: Center(
                      child: Text(minuteDigit2),
                  ),
              ),
              Positioned(
                  left: offset + 4 * widgetWidth + colonWidth,
                  top: offset,
                  child: Center(child: Text(':')),
              ),
              Positioned(
                  left: offset + 4 * widgetWidth + 2 * colonWidth,
                  top: offset,
                  child: Center(
                      child: Text(secondDigit1),
                  ),
              ),
              Positioned(
                  left: offset + 5 * widgetWidth + 2 * colonWidth,
                  top: offset,
                  child: Center(
                      child: Text(secondDigit2),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
