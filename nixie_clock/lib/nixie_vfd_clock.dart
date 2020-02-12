// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';

class _ClockInherited extends InheritedWidget {
  _ClockInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final ClockState data;

  @override
  bool updateShouldNotify(_ClockInherited oldWidget) {
    return true;
  }
}

class NixieVFDClock extends StatefulWidget {
  // InheritedWidget role of the InheritedWidget pattern
  NixieVFDClock({
    Key key,
    this.model,
    this.child,
  }) : super(key: key);

  final ClockModel model;
  final Widget child;

  @override
  ClockState createState() => ClockState();

  static ClockState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_ClockInherited>()).data;
  }
}

class ClockState extends State<NixieVFDClock> {
  // InheritedWidgetState role of the InheritedWidget pattern
  var _rightNow = DateTime.now();
  var _temperature = '';
  var _weather = '';
  var _location = '';
  Timer _timer;

  DateTime get rightNow => _rightNow;
  String get temperature => _temperature;
  String get weather => _weather;
  String get location => _location;
  ClockModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(NixieVFDClock oldWidget) {
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
      _temperature = widget.model.temperatureString;
      _weather = '${widget.model.weatherString}, ' +
          '(${widget.model.low} - ${widget.model.highString})';
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _rightNow = DateTime.now();
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _rightNow.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _ClockInherited(
      data: this,
      child: widget.child,
    );
  }
}
