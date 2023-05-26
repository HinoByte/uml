import 'dart:math';

import 'package:flutter/material.dart';

abstract class LinePainter extends CustomPainter {
  Offset start;
  Offset end;
  final Size sizeStart;
  final Size sizeEnd;
  final double heightOffset;
  double angle;

  LinePainter({
    required this.start,
    required this.end,
    required this.sizeStart,
    required this.sizeEnd,
    this.heightOffset = 0.0,
    this.angle = 0.0,
  });

  Offset get getStart => start;
  Offset get getEnd => end;

  @override
  void paint(Canvas canvas, Size size) {
    drawLineAndText(canvas, start, end);
  }

  void drawLineAndText(Canvas canvas, Offset start, Offset end);

  void calculateCoordinates() {
    List<Offset> edgeCenters(Rect rect, double yOffset) => [
          Offset(rect.left, rect.center.dy + yOffset),
          Offset(rect.right, rect.center.dy + yOffset),
          Offset(rect.center.dx, rect.top - yOffset),
          Offset(rect.center.dx, rect.bottom + yOffset),
        ];

    final objectRect1 =
        Rect.fromLTWH(start.dx, start.dy, sizeStart.height, sizeStart.width);
    final objectRect2 =
        Rect.fromLTWH(end.dx, end.dy, sizeEnd.height, sizeEnd.width);
    var points1 = edgeCenters(objectRect1, heightOffset);
    var points2 = edgeCenters(objectRect2, heightOffset);

    var line = points1
        .expand((p1) => points2.map((p2) => MapEntry(p1, p2)))
        .reduce((value, element) => (value.key - value.value).distance <
                (element.key - element.value).distance
            ? value
            : element);

    angle = atan2(line.value.dy - line.key.dy, line.value.dx - line.key.dx);

    start = Offset(
      line.key.dx + (sizeStart.width / 2) * cos(angle),
      line.key.dy + (sizeStart.height / 2) * sin(angle) + heightOffset,
    );

    end = Offset(
      line.value.dx - (sizeEnd.width / 2) * cos(angle),
      line.value.dy - (sizeEnd.height / 2) * sin(angle) + heightOffset,
    );
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.sizeStart != sizeStart ||
        oldDelegate.sizeEnd != sizeEnd ||
        oldDelegate.heightOffset != heightOffset;
  }
}
