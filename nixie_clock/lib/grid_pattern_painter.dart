import 'package:flutter/widgets.dart';


class GridPatternPainter extends CustomPainter {
  Size patternSize;
  Color gridColor;
  Color backgroundColor;

  GridPatternPainter({
    @required this.patternSize,
    @required this.gridColor,
    @required this.backgroundColor,
  })
      : assert(
          patternSize != null &&
          gridColor != null &&
          backgroundColor != null
      );

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = backgroundColor;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, fillPaint);

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..isAntiAlias = true;

    for (var j = patternSize.width; j < size.width; j += patternSize.width) {
      canvas.drawLine(Offset(j, 0), Offset(j, size.height), gridPaint);
      for (var i = patternSize.height; i < size.height; i += patternSize.height) {
        canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
