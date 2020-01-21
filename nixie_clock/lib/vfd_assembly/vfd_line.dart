import 'package:flutter/material.dart';

import 'vfd_character.dart';
import 'vfd_painter.dart';

class VFDLine extends StatelessWidget {
  VFDLine({
    this.text,
    this.maxChars,
    this.backgroundPainter,
    this.foregroundPainter,
  });

  final String text;
  final int maxChars;
  final VFDPainter backgroundPainter;
  final VFDPainter foregroundPainter;

  @override
  Widget build(BuildContext context) {
    final List<Widget> vfdCharacters = [];
    text
        .padRight(maxChars, ' ')
        .split('')
        .forEach((character) => vfdCharacters.add(VFDCharacter(
              character: character,
              backgroundPainter: backgroundPainter,
              foregroundPainter: foregroundPainter,
            )));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: vfdCharacters,
    );
  }
}
