import 'package:flutter/material.dart';
import 'package:uml/models/uml_object_type.dart';
import 'package:uml/utils/entity.dart';
import 'package:uml/utils/visual_object.dart';
import 'package:uml/widgets/painters/objects/actor_painter.dart';
import 'package:uml/widgets/painters/objects/precedent_painter.dart';

class UmlObject extends Entity implements IVisualObject {
  final int? id;
  final int? diagramId;
  final String? name;
  final ObjectType? objectType;
  final double? x;
  final double? y;

  UmlObject({
    this.id,
    this.diagramId,
    this.name,
    this.objectType,
    this.x,
    this.y,
  });

  factory UmlObject.fromJson(Map<String, dynamic> json) {
    return UmlObject(
      id: json['id'],
      diagramId: json['diagram_id'],
      name: json['name'],
      objectType: json['object_type'] == null
          ? null
          : ObjectType.fromJson(json['object_type']),
      x: json['X'],
      y: json['Y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diagram_id': diagramId,
      'name': name,
      'object_type': objectType,
      'X': x,
      'Y': y,
    };
  }

  @override
  String toString() {
    return 'UmlObject{diagramId: $diagramId, name: $name, objectType: $objectType, X: $x, Y: $y}';
  }

  @override
  Offset position = const Offset(300, 300);

  @override
  CustomPainter Function() get customPainter {
    return () {
      switch (objectType?.name) {
        case 'Actor':
          return ActorPainter();
        case 'UseCase':
          return PrecedentPainter();
        case 'Boundary':
          return PrecedentPainter();
        default:
          return ActorPainter(); 
      }
    };
  }

  @override
  set customPainter(CustomPainter Function() customPainter) {}
}
