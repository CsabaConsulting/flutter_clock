import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';


class NixieBackgroundPainter extends CustomPainter {
  double side;
  Paint partFillPaint;
  Paint partStrokePaint;
  Paint partStrokePaintThick;
  final double _hexHeight;

  NixieBackgroundPainter({
    this.side,
    @required this.partFillPaint,
    @required this.partStrokePaint,
    @required this.partStrokePaintThick,
  })
    : assert(
        partFillPaint != null &&
        partStrokePaint != null &&
        partStrokePaintThick != null
    ),
      _hexHeight = side * sqrt(3);

  Path _createBottom(Canvas canvas, Size size, double bottom) {
    return Path()
      ..moveTo(3, bottom + 1)
      ..lineTo(size.width - 3, bottom + 1)
      ..lineTo(size.width - 3 * side, bottom + _hexHeight + 2)
      ..lineTo(side * 3, bottom + _hexHeight + 2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseHeight = size.height * 0.22 - _hexHeight / 2 - 1;
    final bottom = baseHeight + size.height * 0.645;

    // Bottom
    final bottomPath = _createBottom(canvas, size, bottom);
    bottomPath.close();
    canvas.drawPath(bottomPath, partFillPaint);

    // Top
    canvas.drawRect(
      Rect.fromLTRB(
        side - 1,
        baseHeight - _hexHeight / 1.5,
        size.width - side + 1,
        baseHeight,
      ),
      partFillPaint,
    );
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        4 * side,
        baseHeight - 2 * side,
        size.width - 4 * side,
        baseHeight - side,
        topLeft: Radius.circular(side),
        topRight: Radius.circular(side),
      ),
      partStrokePaintThick,
    );

    // Sides
    canvas.drawLine(
      Offset(side - 2, baseHeight - _hexHeight / 1.5),
      Offset(side - 2, bottom + 1),
      partStrokePaint,
    );
    canvas.drawLine(
      Offset(size.width - side + 1, baseHeight - _hexHeight / 1.5),
      Offset(size.width - side + 1, bottom + 1),
      partStrokePaint,
    );

    // Ring
    canvas.drawCircle(
      Offset(size.width / 2, baseHeight - 3 * side - 2),
      side + 1,
      partStrokePaintThick,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
