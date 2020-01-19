import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';

class NixieBackgroundPainter extends CustomPainter {
  double side;
  Paint partFillPaint;
  Paint partStrokePaint;
  Paint partStrokePaintThick;
  Paint nixieOffPaint;
  final double _hexHeight;

  NixieBackgroundPainter({
    this.side,
    @required this.partFillPaint,
    @required this.partStrokePaint,
    @required this.partStrokePaintThick,
    @required this.nixieOffPaint,
  })  : assert(partFillPaint != null &&
            partStrokePaint != null &&
            partStrokePaintThick != null &&
            nixieOffPaint != null),
        _hexHeight = side * sqrt(3);

  Path _createBottom(Canvas canvas, Size size, double bottom) {
    return Path()
      ..moveTo(3, bottom + 1)
      ..lineTo(size.width - 3, bottom + 1)
      ..lineTo(size.width - 3 * side, bottom + _hexHeight + 2)
      ..lineTo(side * 3, bottom + _hexHeight + 2);
  }

  void paintHexagonTop(Canvas canvas, Size size, double baseHeight) {
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
  }

  void paintHexagonSides(
      Canvas canvas, Size size, double baseHeight, double bottom) {
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
  }

  void paintHexagonHangerRing(Canvas canvas, Size size, double baseHeight) {
    canvas.drawCircle(
      Offset(size.width / 2, baseHeight - 3 * side - 2),
      side + 1,
      partStrokePaintThick,
    );
  }

  void paintDigitHangerTopRing(Canvas canvas, Size size, double baseHeight) {
    canvas.drawCircle(
      Offset(size.width / 2, baseHeight + 2 * side - 2),
      side + 1,
      nixieOffPaint,
    );
  }

  void paintDigitHangerBottomRing(Canvas canvas, Size size, double bottom) {
    canvas.drawCircle(
      Offset(size.width / 2, bottom - 1.5 * side),
      side + 1,
      nixieOffPaint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseHeight = size.height * 0.22 - _hexHeight / 2.0 - 1.0;
    final bottom = baseHeight + size.height * 0.645;

    final bottomPath = _createBottom(canvas, size, bottom);
    bottomPath.close();
    canvas.drawPath(bottomPath, partFillPaint);

    paintHexagonTop(canvas, size, baseHeight);
    paintHexagonSides(canvas, size, baseHeight, bottom);
    paintHexagonHangerRing(canvas, size, baseHeight);
    paintDigitHangerTopRing(canvas, size, baseHeight);
    paintDigitHangerBottomRing(canvas, size, bottom);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
