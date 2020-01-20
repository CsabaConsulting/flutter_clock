import 'package:flutter/material.dart';

import '../color_configuration.dart';
import 'vfd_character.dart';
import 'vfd_painter.dart';

class VFDLine extends StatelessWidget {
  VFDLine({
    this.colorSet,
    this.text,
    this.maxChars,
    this.charSize,
    this.charMargin,
    this.pixelSize,
    this.backgroundPainter,
    this.foregroundPainter,
  });

  final Map<ColorSelector, Color> colorSet;
  final String text;
  final int maxChars;
  final Size charSize;
  final Size charMargin;
  final Size pixelSize;
  final VFDPainter backgroundPainter;
  final VFDPainter foregroundPainter;

  @override
  Widget build(BuildContext context) {
    final List<Widget> vfdCharacters = [];
    text.padRight(maxChars, ' ').split('').forEach((character) =>
      vfdCharacters.add(
        VFDCharacter(
          colorSet: colorSet,
          character: character,
          charSize: charSize,
          charMargin: charMargin,
          pixelSize: pixelSize,
          backgroundPainter: backgroundPainter,
          foregroundPainter: foregroundPainter,
        )
      )
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: vfdCharacters,
    );
  }
}
