import 'package:flutter/material.dart';
import 'package:uml/models/diagram.dart';
import 'package:uml/models/uml_object_type.dart';
import 'package:uml/utils/visual_object.dart';
import 'package:uml/widgets/painters/objects/actor_painter.dart';
import 'package:uml/widgets/painters/objects/precedent_painter.dart';

class UmlObject  implements IVisualObject {
  int? id;
  Diagram? diagram;
  String? name;
  ObjectType? objectType;
  double? x;
  double? y;
  double? dimension;

  UmlObject({
    this.id,
    this.diagram,
    this.name,
    this.objectType,
    this.x,
    this.y,
    this.dimension,
  });

  factory UmlObject.fromJson(Map<String, dynamic> json) {
    return UmlObject(
      id: json['id'],
      diagram: json['diagram_id'] == null
          ? null
          : Diagram.fromJson(json['diagram_id']),
      name: json['name'],
      objectType: json['object_type'] == null
          ? null
          : ObjectType.fromJson(json['object_type']),
      x: json['X'],
      y: json['Y'],
      dimension: json['dimension'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diagram': diagram,
      'name': name,
      'object_type': objectType,
      'X': x,
      'Y': y,
      'dimension': dimension,
    };
  }

  @override
  String toString() {
    return 'UmlObject{id: $id, diagram: $diagram, name: $name, objectType: $objectType, X: $x, Y: $y, dimension: $dimension}';
  }

  @override
  Offset position = const Offset(300, 300);

  @override
  String Function() get elementText {
    return () {
      switch (objectType?.name) {
        case 'Association':
          return '─────────';
        // case 'Generalization':
        //   return GeneralizationPainter();
        case 'Dependency':
          return '────────►';
        case 'Include':
          return '────────►';
        // case 'Extend':
        //   return ExtendPainter();
        default:
          return '─────────'; // вернуть стандартный Painter, если другие не подходят
      }
    };
  }

  @override
  CustomPainter Function() get customPainter {
    return () {
      switch (objectType?.name) {
        case 'Actor':
          return ActorPainter(text: name != null ? name! : '');
        case 'UseCase':
          return PrecedentPainter(text: name != null ? name! : '');
        case 'Boundary':
          return PrecedentPainter(text: name != null ? name! : '');
        default:
          return ActorPainter(text: name != null ? name! : '');
      }
    };
  }

  @override
  set customPainter(CustomPainter Function() customPainter) {}

  @override
  set elementText(String Function() elementText) {}

  @override
  set newName(String newName) {
    name = newName;
  }

   @override
  set newId(int newId) {
    id = newId;
  }

  @override
  Size get size =>
      dimension == null ? const Size(100,100) : Size(dimension!, dimension!);

  @override
  set size(Size? newSize) {
    print(dimension);
    dimension = newSize!.height;
        print("$dimension new");

  }

  @override
  String get getName => name ?? '';


void merge(UmlObject other) {
  print("start ${other.position.dx}");
  id = other.id ?? id;
  diagram = other.diagram ?? diagram;
  name = other.name ?? name;
  objectType = other.objectType ?? objectType;
  x = other.position.dx;
  y = other.position.dy;
  dimension = other.dimension ?? dimension;
}


  // UmlObject merge(UmlObject other) {
  //   return UmlObject(
  //     id: id ?? other.id,
  //     diagram: diagram ?? other.diagram,
  //     name: name ?? other.name,
  //     objectType: objectType ?? other.objectType,
  //     x: x ?? other.x,
  //     y: y ?? other.y,
  //     dimension: dimension ?? other.dimension,
  //   );
  // }



  // @override
  // Size get dimension => Size(x ?? 100, y ?? 100);

  // @override
  //   set dimension(Size value) {

  // }
}
