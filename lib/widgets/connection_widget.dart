import 'package:flutter/material.dart';
import 'package:uml/models/relationship.dart';
import 'package:uml/models/uml_object.dart';
import 'package:uml/utils/connections.dart';
import 'package:uml/utils/visual_object.dart';

import 'painters/relationships_painters/association_painter.dart';

class ConnectionWidget extends StatefulWidget {
  final IVisualObject object;
  final List<IVisualObject> visualObjects;
  final bool inTable;
  final Relationship? activeConnection;
  final ValueChanged<IVisualObject?>? onCheckboxChanged;

  const ConnectionWidget({
    super.key,
    required this.object,
    required this.visualObjects,
    this.inTable = false,
    this.activeConnection,
    this.onCheckboxChanged,
  });

  @override
  _ConnectionWidgetState createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  @override
  Widget build(BuildContext context) {
    Relationship relationship = widget.object as Relationship;

    // var startLine = widget.visualObjects[0].position - widget.object.position;
    // var endLine = widget.visualObjects[1].position - widget.object.position;
    // if (relationship.objectStart == null && relationship.objectEnd == null && widget.inTable) {
    var startLine;
    var endLine;

    if (widget.inTable &&
        relationship.objectStart != null &&
        relationship.objectEnd != null) {
      for (var object in widget.visualObjects) {
        if (object == relationship.objectStart!) {
          // print('стартовый ${relationship.objectStart!} ${relationship.objectEnd!}}');
          startLine =
              relationship.objectStart!.position - widget.object.position;
              print('widget.object.position ${widget.object.position}');
        }
        if (object == relationship.objectEnd!) {
          // print(relationship.objectStart!);
          endLine = relationship.objectEnd!.position - widget.object.position;
        }
      }

      // print(relationship.objectStart!.position);
      // var startLine = relationship.objectStart!.position - widget.object.position;
      // var endLine = relationship.objectEnd!.position - widget.object.position;
      //relationship = 
      print("endLine $endLine");
      widget.object as Relationship
        ..start = startLine
        ..end = endLine;
      return CustomPaint(
        // size: const Size(0, 0),
        painter:
      widget.object.customPainter(),
      //   AssociationPainter(
      //     object: widget.object,
      //     color: relationship.hasConnectedDiagrams ? Colors.green : Colors.black,
      //     start: startLine,
      //     end: endLine,
      //     sizeStart: relationship.objectStart?.size ?? const Size(100,100),
      //     sizeEnd: relationship.objectEnd?.size ??  const Size(100,100),
      //     heightOffset: relationship.y ?? 0.0,
      //  ),
      );
    } else if (!widget.inTable) {
      return _buildLine(widget.object.elementText());
    } else {
      return Container();
    }
  }

  Row _buildLine(String elementText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: (widget.object as Relationship).leftCheckboxValue,
          onChanged: widget.activeConnection == null ||
                  widget.activeConnection == widget.object
              ? (value) {
                  setState(() {
                    (widget.object as Relationship).leftCheckboxValue = value!;
                  });
                  if ((widget.object as Relationship).leftCheckboxValue) {
                    widget.onCheckboxChanged?.call(widget.object);
                  } else {
                    widget.onCheckboxChanged?.call(null);
                    (widget.object as Relationship).objectStart = null;
                  }
                }
              : null,
          shape: const CircleBorder(),
          // checkColor: Colors.white, // Здесь задаем цвет галочки
          fillColor: MaterialStateProperty.resolveWith((states) {
            if ((widget.object as Relationship).objectStart == null) {
              return Colors.blue;
            }
            if (states.contains(MaterialState.selected)) {
              return Colors.green;
            }
            return null; // Для других состояний
          }),
        ),
        Text(elementText, style: const TextStyle(fontSize: 10,
        fontWeight: FontWeight.w900)),
        Checkbox(
          value: (widget.object as Relationship).rightCheckboxValue,
          onChanged: widget.activeConnection == null ||
                  widget.activeConnection == widget.object
              ? (value) {
                  setState(() {
                    (widget.object as Relationship).rightCheckboxValue = value!;
                  });
                  if ((widget.object as Relationship).rightCheckboxValue) {
                    widget.onCheckboxChanged?.call(widget.object);
                  } else {
                    widget.onCheckboxChanged?.call(null);
                    (widget.object as Relationship).objectEnd = null;
                  }
                }
              : null,

          // (value) {
          //   print(widget.object);
          //   // if ((widget.object as Relationship).leftCheckboxValue) {
          //   //   (widget.object as Relationship).objectStart = null;
          //   //   print(widget.object as Relationship);
          //   //   print('semd');
          //   // }
          //   setState(() {
          //     (widget.object as Relationship).leftCheckboxValue = value!;
          //   });
          //   if ((widget.object as Relationship).leftCheckboxValue) {
          //     widget.onCheckboxChanged?.call(null);
          //    (widget.object as Relationship).objectStart = null;
          //   } else {
          //     widget.onCheckboxChanged?.call(widget.object);
          //   }

          // widget.onCheckboxChanged?.call(widget.object);
          //},
          shape: const CircleBorder(),
          //checkColor: Colors.white, // Здесь задаем цвет галочки
          fillColor: MaterialStateProperty.resolveWith((states) {
            if ((widget.object as Relationship).objectEnd == null) {
              return Colors.blue; // Цвет фона, когда objectStart == null
            }
            if (states.contains(MaterialState.selected)) {
              return Colors.green; // Цвет фона, когда чекбокс выбран
            }
            return null; // Для других состояний
          }),
        ),
        //     Checkbox(
        //       value: (widget.object as Relationship).rightCheckboxValue,
        //       onChanged: (_) {
        //         var rel = widget.object as Relationship;
        //         // print(widget.object);
        //         // print((widget.object as Relationship).objectEnd);
        //         // print(widget.object);
        //         // print((widget.object as Relationship).objectEnd);
        //         if (rel.objectEnd == null) {
        //           // (widget.object as Connection).leftCheckboxValue = true;
        //           // print('2');
        //           // (widget.object as Relationship).rightCheckboxValue = true;

        //           // print((widget.object as Connection).leftCheckboxValue);

        //           // print((widget.object as Connection).rightCheckboxValue);
        //         } else {
        //           setState(() {
        //             (widget.object as Relationship).objectStart = null;

        //             //print((widget.object as Connection).leftCheckboxValue);
        //             // print('1');
        //             // print((widget.object as Connection).leftCheckboxValue);
        //             // print((widget.object as Connection).rightCheckboxValue);

        //             // (widget.object as Relationship).objectEnd = null;
        //             // (widget.object as Connection).leftCheckboxValue = false;
        //             //  print((widget as Connection).leftCheckboxValue);
        //           });
        //         }
        //       },

        //       // ? (widget.object as Relationship).objectEnd == null);
        //       //   }
        //       // : (value) {
        //       //     setState(() {
        //       //       (widget.object as Relationship).rightCheckboxValue = value!;
        //       //     });
        //       //   },
        //       shape: const CircleBorder(),
        //       fillColor: MaterialStateProperty.resolveWith((states) {
        //         // if ((widget.object as Relationship).objectEnd != null) {
        //         //   return Colors.red; // Цвет фона, когда objectStart == null
        //         // }
        //         if (states.contains(MaterialState.selected)) {
        //           return Colors.green; // Цвет фона, когда чекбокс выбран
        //         }

        //         return null; // Для других состояний
        //       }),
        //     ),
      ],
    );
  }
}



  // Row _buildLine(String elementText) {
  //   final isActive = widget.object != widget.activeConnection;
  //   print(widget.activeConnection);
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Checkbox(
  //         value: (widget.object as Relationship).leftCheckboxValue,
  //         onChanged: isActive
  //             ? (value) {
  //                 setState(() {
  //                   (widget.object as Relationship).leftCheckboxValue = value!;
  //                 });
  //               }
  //             : null,
  //         shape: const CircleBorder(),
  //       ),
  //       Text(elementText, style: TextStyle(fontSize: 24)),
  //       Checkbox(
  //         value: (widget.object as Relationship).rightCheckboxValue,
  //         onChanged: isActive
  //             ? (value) {
  //                 setState(() {
  //                   (widget.object as Relationship).rightCheckboxValue = value!;
  //                 });
  //               }
  //             : null,
  //         shape: const CircleBorder(),
  //       ),
  //     ],
  //   );
  // }


   // print(!rel.isArrowConnected);
    // return !rel.isArrowConnected
    //     ? SizedBox(
    //         width: 20,
    //         child:
    //             _buildLine(startLine, endLine, widget.object.customPainter()))
    //     : SizedBox(
    //         width: 20,
    //         child: _buildRow(
    //           startLine,
    //           endLine,
    //           AssociationPainter(
    //             object: widget.object,
    //             color: rel.hasConnectedDiagrams ? Colors.green : Colors.black,
    //             start: startLine,
    //             end: endLine,
    //             sizeStart: 100,
    //             sizeEnd: 100,
    //           ),
    //         ),
    //       );