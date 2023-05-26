import 'package:flutter/material.dart';

import 'dart:ui' as ui;

class PrecedentPainter extends CustomPainter {
  final String text;

  PrecedentPainter({required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Рисуем овал
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: size.height * 0.6,
    );
    canvas.drawOval(rect, paint);

    final textStyle = ui.TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final paragraphStyle = ui.ParagraphStyle(
      textAlign: TextAlign.center,
    );

    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(text);

    final constraints = ui.ParagraphConstraints(width: rect.width);
    final paragraph = paragraphBuilder.build()..layout(constraints);

    final offset = Offset((size.width - paragraph.width) / 2, (size.height - paragraph.height) / 2);

    canvas.drawParagraph(paragraph, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}