import 'package:flutter/material.dart';

class ActorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Рисуем голову
    canvas.drawCircle(Offset(center.dx, center.dy - size.height / 4), size.width / 4, paint);

    // Рисуем туловище
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx, center.dy + size.height / 4),
      paint,
    );

    // Рисуем руки
    canvas.drawLine(
      Offset(center.dx, center.dy + size.height / 8),
      Offset(center.dx - size.width / 4, center.dy + size.height / 8),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + size.height / 8),
      Offset(center.dx + size.width / 4, center.dy + size.height / 8),
      paint,
    );

    // Рисуем ноги
    canvas.drawLine(
      Offset(center.dx, center.dy + size.height / 4),
      Offset(center.dx - size.width / 4, center.dy + size.height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + size.height / 4),
      Offset(center.dx + size.width / 4, center.dy + size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}