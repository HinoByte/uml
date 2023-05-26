import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uml/models/relationship.dart';
import 'package:uml/utils/visual_object.dart';
import 'package:uml/widgets/painters/relationships_painters/line_painter.dart';

class AssociationPainter extends LinePainter {
  final String text;

  AssociationPainter(
      {required Offset start,
      required Offset end,
      required Size sizeStart,
      required Size sizeEnd,
      double heightOffset = 0.0,
      required this.text})
      : super(
            start: start,
            end: end,
            sizeStart: sizeStart,
            sizeEnd: sizeEnd,
            heightOffset: heightOffset);

  @override
  void drawLineAndText(Canvas canvas, Offset start, Offset end) {
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant AssociationPainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.sizeStart != sizeStart ||
        oldDelegate.sizeEnd != sizeEnd ||
        oldDelegate.heightOffset != heightOffset;
  }
}
