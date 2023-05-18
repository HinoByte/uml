import 'package:flutter/material.dart';

class AssociationPainter extends CustomPainter {
  final Offset? start;
  final Offset? end;

  AssociationPainter({this.start, this.end});

  List<Offset> edgeCenters(Rect rect) {
    return [
      Offset(rect.left, rect.center.dy),
      Offset(rect.right, rect.center.dy),
      Offset(rect.center.dx, rect.top),
      Offset(rect.center.dx, rect.bottom),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    int objectCount = (start != null ? 1 : 0) + (end != null ? 1 : 0);

    if (objectCount == 0) {
      // Начальная точка на левой границе области рисования
      Offset lineStart = Offset(0, size.height / 2);

      // Конечная точка на правой границе области рисования
      Offset lineEnd = Offset(size.width, size.height / 2);

      // Рисуем линию
      canvas.drawLine(lineStart, lineEnd, paint);
    } else if (objectCount == 1) {
      final objectRect1 = Rect.fromLTWH(start!.dx, start!.dy, 100, 100);
              canvas.drawRect(objectRect1, paint);

      var points1 = edgeCenters(objectRect1);

      var line = points1.map((p1) => MapEntry(p1, end)).reduce(
          (value, element) => (value.key - value.value!).distance <
                  (element.key - element.value!).distance
              ? value
              : element);

      canvas.drawLine(line.key, line.value!, paint);
    } else if (objectCount == 2) {
      final objectRect1 = Rect.fromLTWH(start!.dx, start!.dy, 100, 100);
      final objectRect2 = Rect.fromLTWH(end!.dx, end!.dy, 100, 100);
      var points1 = edgeCenters(objectRect1);
      var points2 = edgeCenters(objectRect2);

      var line = points1
          .expand((p1) => points2.map((p2) => MapEntry(p1, p2)))
          .reduce((value, element) => (value.key - value.value).distance <
                  (element.key - element.value).distance
              ? value
              : element);

      canvas.drawLine(line.key, line.value, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


// class LinePainter extends CustomPainter {
//   final Offset start;
//   final Offset end;

//   LinePainter({required this.start, required this.end});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 2.0;

//     canvas.drawLine(start, end, paint);
//   }

//   // @override
//   // bool shouldRepaint(LinePainter oldDelegate) {
//   //   print(start);
//   //   return oldDelegate.start != start || oldDelegate.end != end;
//   // }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
