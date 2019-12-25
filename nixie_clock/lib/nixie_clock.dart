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
    final time = DateFormat(timeFormat).format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 4.5;
    final offset = fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'TTChocolates',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 10,
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
              Positioned(left: offset, top: offset, child: Text(time)),
//              Positioned(right: offset, bottom: offset, child: Text(minute)),
            ],
          ),
        ),
      ),
    );
  }
}
