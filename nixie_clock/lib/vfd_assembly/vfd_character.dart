import 'package:flutter/material.dart';

import 'vfd_painter.dart';

class VFDCharacter extends StatelessWidget {
  VFDCharacter({
    this.character,
    this.backgroundPainter,
    this.foregroundPainter,
  });

  final String character;
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
