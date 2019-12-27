import 'package:flutter/widgets.dart';


class VFDPainter extends CustomPainter {
  Size characterSize;
  Size characterMargin;
  Size pixelSize;
  Paint gridLinePaint;
  Paint backgroundPaint;

  VFDPainter({
    @required this.characterSize,
    @required this.characterMargin,
    @required this.pixelSize,
    @required this.gridLinePaint,
    this.backgroundPaint,
  })
      : assert(
          characterSize != null &&
          characterMargin != null &&
          pixelSize != null &&
          gridLinePaint != null
      );

  void paintVFDDigitBackground(
      Canvas canvas,
      double digitTop,
      double digitLeft,
      double digitWidth,
      double digitHeight,
      Paint gridLinePaint)
  {
    final top = digitTop + pixelSize.height;
    final right = digitLeft + digitWidth;
    for (var i = top; i < top + digitHeight; i += pixelSize.height) {
      canvas.drawLine(Offset(digitLeft, i), Offset(right, i), gridLinePaint);
    }
    final left = digitLeft + pixelSize.width;
    digitTop += pixelSize.height;
    final bottom = digitTop + digitHeight;
    for (var i = left; i < left + digitWidth; i += pixelSize.width) {
      canvas.drawLine(Offset(i, digitTop), Offset(i, bottom), gridLinePaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final width = characterSize.width - characterMargin.width;
    final height = characterSize.height - characterMargin.height;
    for (var i = 0.0; i < size.height; i += characterSize.height) {
      for (var j = 0.0; j < size.width; j += characterSize.width) {
        if (backgroundPaint != null) {
          final left = j;
          final top = i + characterMargin.height;
          final rect = Rect.fromLTWH(left, top, width, height);
          canvas.drawRect(rect, backgroundPaint);
        }

        paintVFDDigitBackground(canvas, i, j, width, height, gridLinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
