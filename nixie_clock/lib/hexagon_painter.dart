import 'dart:math';

import 'package:flutter/widgets.dart';


enum HexaPosition {
  Start,
  Center,
  Stop,
}

class HexagonPainter extends CustomPainter {
  double side;
  Paint gridLinePaint;
  Paint tubePaint;
  final double _hexWidth;
  final double _hexHeight;

  HexagonPainter({
    this.side,
    @required this.gridLinePaint,
    @required this.tubePaint,
  })
      : assert(gridLinePaint != null && tubePaint != null),
        _hexWidth = side * 2,
        _hexHeight = side * sqrt(3);

  Path _createHexagon(
      Offset offset,
      HexaPosition horizontal,
      HexaPosition vertical,
      bool evenColumn)
  {
    // Pay attention to paint each segment only one time
    if (horizontal == HexaPosition.Start && vertical == HexaPosition.Start) {
      return Path()
        ..moveTo(offset.dx + 0, offset.dy + _hexHeight / 2)
        ..lineTo(offset.dx + side / 2, offset.dy + 0)
        ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 0)
        ..lineTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
        ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
        ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2)
        ..lineTo(offset.dx + 0, offset.dy + _hexHeight / 2);
    } else if (vertical == HexaPosition.Start) {
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
    } else if (horizontal == HexaPosition.Start) {
      return Path()
        ..moveTo(offset.dx + side * 2, offset.dy + _hexHeight / 2)
        ..lineTo(offset.dx + (3 * side) / 2, offset.dy + 2 * _hexHeight / 2)
        ..lineTo(offset.dx + side / 2, offset.dy + 2 * _hexHeight / 2)
        ..lineTo(offset.dx + 0, offset.dy + _hexHeight / 2)
        ..lineTo(offset.dx + side / 2, offset.dy + 0);
    } else {
      if (evenColumn) {
        if (horizontal == HexaPosition.Stop) {
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

  @override
  void paint(Canvas canvas, Size size) {
    for (var y = 0; y < size.height / _hexHeight * 0.6; y++) {
      for (var x = 0; x - 1 < size.width / _hexWidth; x++) {
        final dy = _hexHeight * y + (x % 2) * (_hexHeight / 2);

        final horizontal = x == 0 ? HexaPosition.Start :
          (x + 1 >= size.width / _hexWidth ?
          HexaPosition.Stop : HexaPosition.Center);
        final vertical = y == 0 ? HexaPosition.Start :
          (y + 1 >= size.height / _hexHeight ?
          HexaPosition.Stop : HexaPosition.Center);

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

    final tubePath = _createTube(canvas, size);
    canvas.drawPath(tubePath, tubePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
