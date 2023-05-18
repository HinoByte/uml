import 'dart:ui';

import 'package:flutter/material.dart';

class DependencyPainter extends CustomPainter {
  final String text;
  // final Offset? start;
  // final Offset? end;

  DependencyPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Начальная точка
    path.moveTo(0, 0);

    // Прерывистая линия
    for (int i = 10; i < size.width.toInt(); i += 20) {
      path.lineTo(i.toDouble(), 0);
      path.moveTo(i.toDouble() + 10, 0);
    }

    // Стрелка на конце
    path.moveTo(size.width - 10, -5);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 10, 5);

    canvas.drawPath(path, paint);

    final paragraphStyle = ParagraphStyle(
      textAlign: TextAlign.center,
      maxLines: 1,
    );
    final paragraphBuilder = ParagraphBuilder(paragraphStyle)
      // ..pushStyle(TextStyle(color: Colors.black, fontSize: 16.0))  // Добавляем черный цвет текста
      ..addText(text);

    final paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: size.width));

    // Центрируем текст по горизонтали и вертикали
    final offset = Offset(size.width / 2 - paragraph.width / 2, size.height / 2 - paragraph.height / 2);

    canvas.drawParagraph(paragraph, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}