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
  final double _hexWidth;
  final double _hexHeight;

  HexagonPainter({
    this.side,
    @required this.gridLinePaint,
  })
      : assert(gridLinePaint != null),
        _hexWidth = side * 2,
        _hexHeight = side * sqrt(3);

  Path _createHexagon(
      Offset offset,
      HexaPosition horizontal,
      HexaPosition vertical,
      bool evenColumn)
  {
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

        // NOTE: not doing edge tiling for now
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
