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
  NixieVFDClockWidget({
    this.colorSet,
    this.nixieFontSize,
  });

  final aspectRatioForWidth = 3.5;
  final Map<ColorSelector, Color> colorSet;
  final double nixieFontSize;

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
    final nixieFontSize =
        min(mediaSize.height / aspectRatioForWidth, mediaSize.width / widthDivider);

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
