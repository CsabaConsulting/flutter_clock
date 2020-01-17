import 'package:flutter/widgets.dart';

class VFDPainter extends CustomPainter {
  Size charSize;
  Size charMargin;
  Size pixelSize;
  Paint gridLinePaint;
  Paint backgroundPaint;
  double sideMargins;

  VFDPainter({
    @required this.charSize,
    @required this.charMargin,
    @required this.pixelSize,
    @required this.gridLinePaint,
    this.backgroundPaint,
    @required this.sideMargins,
  }) : assert(charSize != null &&
            charMargin != null &&
            pixelSize != null &&
            gridLinePaint != null &&
            sideMargins != null);

  void paintHorizontalControlGridLineBackground(Canvas canvas, double digitTop,
      double digitLeft, double digitWidth, double digitHeight) {
    final top = digitTop + pixelSize.height;
    final right = digitLeft + digitWidth;
    for (var i = top; i < top + digitHeight; i += pixelSize.height) {
      canvas.drawLine(Offset(digitLeft, i), Offset(right, i), gridLinePaint);
    }
  }

  void paintVerticalControlGridLineBackground(Canvas canvas, double digitTop,
      double digitLeft, double digitWidth, double digitHeight) {
    final left = digitLeft + pixelSize.width;
    digitTop += pixelSize.height;
    final bottom = digitTop + digitHeight;
    for (var i = left; i < left + digitWidth; i += pixelSize.width) {
      canvas.drawLine(Offset(i, digitTop), Offset(i, bottom), gridLinePaint);
    }
  }

  void paintVFDDigitBackground(Canvas canvas, double digitTop, double digitLeft,
      double digitWidth, double digitHeight) {
    paintHorizontalControlGridLineBackground(
        canvas, digitTop, digitLeft, digitWidth, digitHeight);
    paintVerticalControlGridLineBackground(
        canvas, digitTop, digitLeft, digitWidth, digitHeight);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final width = charSize.width - charMargin.width;
    final height = charSize.height - charMargin.height;
    for (var i = 0.0, col = 1;
        i < size.height && col <= 3;
        i += charSize.height, col += 1) {
      for (var j = 0.0; j < size.width - sideMargins; j += charSize.width) {
        if (backgroundPaint != null) {
          final left = j;
          final top = i + charMargin.height;
          final rect = Rect.fromLTWH(left, top, width, height);
          canvas.drawRect(rect, backgroundPaint);
        }

        paintVFDDigitBackground(canvas, i, j, width, height);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
