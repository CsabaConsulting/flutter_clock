// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'color_configuration.dart';
import 'nixie_assembly/nixie_assembly.dart';
import 'vfd_assembly/vfd_assembly.dart';

class NixieVFDClockWidget extends StatelessWidget {
  final aspectRatioForWidth = 3.5;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colorSet = brightness == Brightness.light ? lightTheme : darkTheme;
    final mediaSize = MediaQuery.of(context).size;

    final lineSlope = -1.0 / 1500.0;
    final lineOffset = 179.0 / 30.0;
    final widthDivider = mediaSize.width * lineSlope + lineOffset;
    final nixieFontSize = min(
        mediaSize.height / aspectRatioForWidth,
        mediaSize.width / widthDivider
    );

    return Container(
      color: colorSet[ColorSelector.background],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NixieAssembly(colorSet: colorSet, nixieFontSize: nixieFontSize),
          VFDAssembly(colorSet: colorSet, nixieFontSize: nixieFontSize),
        ],
      ),
    );
  }
}
