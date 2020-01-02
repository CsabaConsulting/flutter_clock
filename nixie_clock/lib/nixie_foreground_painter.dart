import 'dart:math';

import 'package:flutter/widgets.dart';


enum HexPosition {
  Start,
  Center,
  Stop,
}

class NixieForegroundPainter extends CustomPainter {
  double side;
  Paint gridLinePaint;
  Paint tubePaint;
  final double _hexWidth;
  final double _hexHeight;

  NixieForegroundPainter({
    this.side,
    @required this.gridLinePaint,
    @required this.tubePaint,
  })
    : assert(gridLinePaint != null && tubePaint != null),
      _hexWidth = side * 2,
      _hexHeight = side * sqrt(3);

  Path _createHexagon(
      Offset offset,
      HexPosition horizontal,
      HexPosition vertical,
      bool evenColumn)
  {
    // Pay attention to paint each segment only one time
    if (horizontal == HexPosition.Start && vertical == HexPosition.Start) {
      return Path()
        ..moveTo(offset.dx + 0, offset.dy + _hexHeight / 2)
        ..lineTo(offset.dx + side / 2, offset.dy + 0)
        ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 0)
        ..lineTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
        ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
        ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2)
        ..lineTo(offset.dx + 0, offset.dy + _hexHeight / 2);
    } else if (vertical == HexPosition.Start) {
      if (evenColumn) {
        return Path()
          ..moveTo(offset.dx + 0, offset.dy + _hexHeight / 2)
          ..lineTo(offset.dx + side / 2, offset.dy + 0)
          ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 0)
          ..lineTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
          ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
          ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2);
      } else {
        return Path()
          ..moveTo(offset.dx + side / 2, offset.dy + 0)
          ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 0)
          ..lineTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
          ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
          ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2)
          ..lineTo(offset.dx + 0, offset.dy + _hexHeight / 2);
      }
    } else if (horizontal == HexPosition.Start) {
      return Path()
        ..moveTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
        ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
        ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2)
        ..lineTo(offset.dx + 0, offset.dy + _hexHeight / 2)
        ..lineTo(offset.dx + side / 2, offset.dy + 0);
    } else {
      if (evenColumn) {
        if (horizontal == HexPosition.Stop) {
          return Path()
            ..moveTo(offset.dx + (3 * side) / 2, offset.dy + 0)
            ..lineTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
            ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
            ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2);
        } else {
          return Path()
            ..moveTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
            ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
            ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2);
        }
      } else {
        return Path()
          ..moveTo(offset.dx + (3 * side) / 2, offset.dy + 0)
          ..lineTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
          ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
          ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2)
          ..lineTo(offset.dx + 0, offset.dy + _hexHeight / 2);
      }
    }
  }

  void paintHexagonalGrid(Canvas canvas, Size size) {
    for (var y = 0; y < size.height / _hexHeight * 0.6; y++) {
      for (var x = 0; x - 1 < size.width / _hexWidth; x++) {
        final dy = _hexHeight * y + (x % 2) * (_hexHeight / 2);

        final horizontal = x == 0 ? HexPosition.Start :
        (x + 1 >= size.width / _hexWidth ?
        HexPosition.Stop : HexPosition.Center);
        final vertical = y == 0 ? HexPosition.Start :
        (y + 1 >= size.height / _hexHeight ?
        HexPosition.Stop : HexPosition.Center);

        final hex = _createHexagon(
          Offset(
            (x + 1.3) * 1.5 * side - _hexWidth / 2,
            dy - _hexHeight / 2 + size.height * 0.22,
          ),
          horizontal,
          vertical,
          x % 2 == 0,
        );
        canvas.drawPath(hex, gridLinePaint);
      }
    }
  }

  Path _createTube(Canvas canvas, Size size) {
    final tipRect = Rect.fromCircle(
        center: Offset(size.width / 2, 2 * side),
        radius: side
    );

    // Draw the glass tube
    return Path()
      ..moveTo(size.width / 2 - side, side)
      ..arcTo(tipRect, pi, pi, false)
      ..lineTo(size.width / 2 + side, 3 * side)
      ..conicTo(
        size.width / 2 + side, size.width / 4,
        size.width * 3 / 4, size.width / 4,
        2.0,
      )
      ..conicTo(
        size.width, size.width / 4,
        size.width, size.width / 2,
        2.0,
      )
      ..lineTo(size.width, size.height - size.width / 2)
      ..conicTo(
        size.width, size.height - size.width / 4,
        size.width - size.width / 4, size.height - size.width / 4,
        2.0,
      )
      ..lineTo(size.width / 4, size.height - size.width / 4)
      ..conicTo(
        0, size.height - size.width / 4,
        0, size.height - size.width / 2,
        2.0,
      )
      ..lineTo(0, size.width / 2)
      ..conicTo(
        0, size.width / 4,
        size.width / 4, size.width / 4,
        2.0,
      )
      ..conicTo(
        size.width / 2 - side, size.width / 4,
        size.width / 2 - side, 2 * side,
        2.0,
      );
  }

  void paintLegs(Canvas canvas, Size size) {
    final numLegs = 9;
    final bottom = size.height - size.width / 4;
    final spacing = (size.width - 4 * side) / numLegs;
    for (var x = 0; x < numLegs; x++) {
      final xPosition = 3 * side + x * spacing;
      canvas.drawLine(
        Offset(xPosition, bottom),
        Offset(xPosition, size.height - side),
        tubePaint,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintHexagonalGrid(canvas, size);

    final tubePath = _createTube(canvas, size);
    canvas.drawPath(tubePath, tubePaint);

    paintLegs(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
