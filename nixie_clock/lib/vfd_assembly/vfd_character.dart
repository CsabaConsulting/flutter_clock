import 'package:flutter/material.dart';

import '../color_configuration.dart';
import 'vfd_painter.dart';

class VFDCharacter extends StatelessWidget {
  VFDCharacter({
    this.colorSet,
    this.character,
    this.charSize,
    this.charMargin,
    this.pixelSize,
    this.backgroundPainter,
    this.foregroundPainter,
  });

  final Map<ColorSelector, Color> colorSet;
  final String character;
  final Size charSize;
  final Size charMargin;
  final Size pixelSize;
  final VFDPainter backgroundPainter;
  final VFDPainter foregroundPainter;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: backgroundPainter,
        foregroundPainter: foregroundPainter,
        child: Text(character),
      ),
    );
  }
}
