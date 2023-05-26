import 'dart:math';
import 'dart:ui';

import 'package:uml/models/relationship.dart';
import 'package:uml/utils/visual_object.dart';
import 'package:uml/widgets/painters/relationships_painters/line_painter.dart';

class GeneralizationPainter extends LinePainter {
  final String text;

  GeneralizationPainter(
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

    const arrowLength = 20.0;
    const arrowAngle = pi / 6; 

    final arrowBase1 = Offset(
      end.dx - arrowLength * cos(angle - arrowAngle),
      end.dy - arrowLength * sin(angle - arrowAngle),
    );
    final arrowBase2 = Offset(
      end.dx - arrowLength * cos(angle + arrowAngle),
      end.dy - arrowLength * sin(angle + arrowAngle),
    );

    final lineEnd = Offset(
      end.dx - arrowLength * cos(angle),
      end.dy - arrowLength * sin(angle),
    );
    canvas.drawLine(start, lineEnd, paint);

    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrowBase1.dx, arrowBase1.dy)
      ..lineTo(arrowBase2.dx, arrowBase2.dy)
      ..close();

    canvas.drawPath(arrowPath, paint);

    final paragraphStyle = ParagraphStyle(
      textAlign: TextAlign.center,
      maxLines: 1,
    );
    canvas.drawPath(arrowPath, paint);

    final paragraphBuilder = ParagraphBuilder(paragraphStyle)
      ..pushStyle(TextStyle(
          color: const Color(0xFF000000),
          fontSize: 16.0)) 
      ..addText(text);
    double lineLength = sqrt((end.dx - start.dx) * (end.dx - start.dx) +
        (end.dy - start.dy) * (end.dy - start.dy));

    final paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: lineLength));

    final middlePoint = Offset(
      start.dx + (end.dx - start.dx) / 2,
      start.dy + (end.dy - start.dy) / 2,
    );

    canvas.save();
    canvas.translate(middlePoint.dx, middlePoint.dy);
    canvas.rotate(angle);

    final offset = Offset(-paragraph.width / 2, -paragraph.height / 2 - 10);
    canvas.drawParagraph(paragraph, offset);

    canvas.restore();
  }
}
