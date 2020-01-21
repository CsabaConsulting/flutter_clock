import 'package:flutter/widgets.dart';

class VFDPainter extends CustomPainter {
  Size charSize;
  Size charMargin;
  Size pixelSize;
  Paint gridLinePaint;
  Paint backgroundPaint;

  VFDPainter({
    @required this.charSize,
    @required this.charMargin,
    @required this.pixelSize,
    @required this.gridLinePaint,
    this.backgroundPaint,
  }) : assert(charSize != null &&
            charMargin != null &&
            pixelSize != null &&
            gridLinePaint != null);

  void paintHorizontalControlGridLineBackground(Canvas canvas, double digitLeft,
      double digitTop, double digitWidth, double digitHeight) {
    final top = digitTop + pixelSize.height;
    final right = digitLeft + digitWidth;
    for (var i = top; i < top + digitHeight; i += pixelSize.height) {
      canvas.drawLine(Offset(digitLeft, i), Offset(right, i), gridLinePaint);
    }
  }

  void paintVerticalControlGridLineBackground(Canvas canvas, double digitLeft,
      double digitTop, double digitWidth, double digitHeight) {
    final left = digitLeft + pixelSize.width;
    digitTop += pixelSize.height;
    final bottom = digitTop + digitHeight;
    for (var i = left; i < left + digitWidth; i += pixelSize.width) {
      canvas.drawLine(Offset(i, digitTop), Offset(i, bottom), gridLinePaint);
    }
  }

  void paintVFDDigitBackground(Canvas canvas, double digitLeft, double digitTop,
      double digitWidth, double digitHeight) {
    paintHorizontalControlGridLineBackground(
        canvas, digitLeft, digitTop, digitWidth, digitHeight);
    paintVerticalControlGridLineBackground(
        canvas, digitLeft, digitTop, digitWidth, digitHeight);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final width = charSize.width - charMargin.width;
    final height = charSize.height - charMargin.height;
    if (backgroundPaint != null) {
      final rect = Rect.fromLTWH(2, charMargin.height, width, height);
      canvas.drawRect(rect, backgroundPaint);
    }

    paintVFDDigitBackground(canvas, 2, 0, width, height);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
