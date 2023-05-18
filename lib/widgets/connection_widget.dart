import 'package:flutter/material.dart';
import 'package:uml/models/relationship.dart';
import 'package:uml/utils/visual_object.dart';

import 'painters/relationships_painters/association_painter.dart';

class ConnectionWidget extends StatefulWidget {
  final IVisualObject object;
  final List<IVisualObject> visualObjects;

  const ConnectionWidget({
    super.key,
    required this.object,
    required this.visualObjects,
  });

  @override
  _ConnectionWidgetState createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  @override
  Widget build(BuildContext context) {
    var startLine = widget.visualObjects[0].position - widget.object.position;
    var endLine = widget.visualObjects[1].position - widget.object.position;
    print('${widget.visualObjects[0].position} visualObjects[0].position');
    var rel = widget.object as Relationship
      ..start = startLine
      ..end = endLine;
    print('rel.position позиция внутри элемента ${rel.position}');

    return !rel.isArrowConnected
        ? _buildLine(startLine, endLine, widget.object.customPainter())
        : _buildRow(
            startLine,
            endLine,
            AssociationPainter(
              object: widget.object,
              color: rel.hasConnectedDiagrams ? Colors.green : Colors.black,
              start: startLine,
              end: endLine,
            ),
          );
  }

  CustomPaint _buildRow(
      Offset startLine, Offset endLine, CustomPainter painter) {
    return
        //  height: 8,
        //width: 150,

        CustomPaint(
      size: const Size(0, 0),
      painter: painter,
    );
  }

  Row _buildLine(Offset startLine, Offset endLine, CustomPainter painter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: (widget.object as Relationship).leftCheckboxValue,
          onChanged: (value) {
            setState(() {
              (widget.object as Relationship).leftCheckboxValue = value!;
            });
          },
          shape: const CircleBorder(),
        ),
        Container(
          //  height: 8,
          //width: 150,

          child: CustomPaint(
            size: const Size(0, 0),
            painter: painter,
          ),
        ),
        Checkbox(
          value: (widget.object as Relationship).rightCheckboxValue,
          onChanged: (value) {
            setState(() {
              (widget.object as Relationship).rightCheckboxValue = value!;
            });
          },
          shape: const CircleBorder(),
        ),
      ],
    );
  }
}
