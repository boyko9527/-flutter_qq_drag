import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class BezierPainter extends CustomPainter {
  Offset during;
  Offset end;

  double lineWidth = 7;
  double ratio = 1;

  BezierPainter(Offset during, Offset end) {
    if (during == null) return;
    this.during = Offset(during.dx + 15, during.dy + 15);
    this.end = Offset(end.dx + 15, end.dy + 15);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    if (during == null) return;

    paint.color = Colors.red;
    var path = Path();

    var angleA = atan((during.dx - end.dx) / (end.dy - during.dy));
    var length = ((during.dx - end.dx) / sin(angleA)).abs();
    ratio = max(1 - length * 0.01, 0.2);
    if (length < 100) {
      var temp_dx = cos(angleA) * lineWidth;
      var temp_dy = sin(angleA) * lineWidth;
      var firstControlPoint = Offset(end.dx + (during.dx - end.dx) / 2, during.dy + (end.dy - during.dy) / 2);
      var firstPoint = Offset(during.dx + temp_dx, during.dy + temp_dy);
      var secondPoint = Offset(end.dx - temp_dx * ratio, end.dy - temp_dy * ratio);

      /**
          p1                          p3
            |------------------------|
            |                        |
            |                        |
            |------------------------|
          p2                          p4
       */
      // 原点 -> p1
      path.moveTo(end.dx - temp_dx * ratio, end.dy - temp_dy * ratio);
      // p1 -> p2
      path.lineTo(end.dx + temp_dx * ratio, end.dy + temp_dy * ratio);
      // p2 -> p4
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstPoint.dx, firstPoint.dy);
      // p4 -> p3
      path.lineTo(during.dx - temp_dx, during.dy - temp_dy);
      // p3 -> p1
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, secondPoint.dx, secondPoint.dy);

      canvas.drawPath(path, paint);
      canvas.drawCircle(end, lineWidth * ratio, paint);
    }
    canvas.drawCircle(during, lineWidth, paint);

    // 文字
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    var tp = textPainter
      ..text = TextSpan(
        text: '3',
        style: new TextStyle(
          color: Colors.white,
          fontSize: 9.0,
        ),
      )..layout();

    tp.paint(canvas, Offset(during.dx- tp.width / 2, during.dy- tp.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }


}
