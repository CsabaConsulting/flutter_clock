import 'dart:math';

import 'package:flutter/widgets.dart';


class HexagonPainter extends CustomPainter {
  Size areaSize;
  double side;
  Paint gridLinePaint;
  final double _hexWidth;
  final double _hexHeight;

  HexagonPainter({
    @required this.areaSize,
    this.side,
    @required this.gridLinePaint,
  })
      : assert(areaSize != null && gridLinePaint != null),
        _hexWidth = side * 2,
        _hexHeight = side * sqrt(3);

  Path _createHexagon(Offset offset) {
    return Path()
      ..moveTo(offset.dx + 0, offset.dy + _hexHeight / 2)
      ..lineTo(offset.dx + side / 2, offset.dy + 0)
      ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 0)
      ..lineTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
      ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
      ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2)
      ..lineTo(offset.dx + 0, offset.dy + _hexHeight / 2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var y = 0; y < size.height / _hexHeight; y++) {
      for (var x = 0; x < size.width / _hexWidth; x++) {
        final dy = _hexHeight * y + (x % 2) * (_hexHeight / 2);

        final hex = _createHexagon(
          Offset(
            x * 1.5 * side - _hexWidth / 2,
            dy - _hexHeight / 2
          )
        );
        canvas.drawPath(hex, gridLinePaint);

        // NOTE: not doing edge tiling for now
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
