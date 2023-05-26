import 'package:flutter/material.dart';
import 'package:uml/models/relationship_type.dart';
import 'package:uml/models/uml_object.dart';
import 'package:uml/utils/connections.dart';
import 'package:uml/utils/visual_object.dart';
import 'package:uml/widgets/painters/relationships_painters/association_painter.dart';
import 'package:uml/widgets/painters/relationships_painters/dependency_painter.dart';
import 'package:uml/widgets/painters/relationships_painters/generalization_painter.dart';
import 'package:uml/widgets/painters/relationships_painters/line_painter.dart';

class Relationship extends Connection implements IVisualObject {
  int? id;
  UmlObject? objectStart;
  UmlObject? objectEnd;
  final RelationshipType? relationshipType;
  String? name;
  double? y;

  Relationship({
    this.id,
    this.objectStart,
    this.objectEnd,
    this.relationshipType,
    this.name,
    this.y = 0,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      id: json['id'],
      objectStart: json['object_start'] == null
          ? null
          : UmlObject.fromJson(json['object_start']),
      objectEnd: json['object_end'] == null
          ? null
          : UmlObject.fromJson(json['object_end']),
      relationshipType: json['relationship_type'] == null
          ? null
          : RelationshipType.fromJson(json['relationship_type']),
      name: json['name'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object_start': objectStart,
      'object_end': objectEnd,
      'relationship_type': relationshipType,
      'name': name,
      'y': y,
    };
  }

  @override
  String toString() {
    return 'Relationship{id: $id, object_start: $objectStart, object_end: $objectEnd, relationshipType: $relationshipType, name: $name, y: $y}';
  }

  @override
  Offset position = Offset.zero;

  // @override
  // CustomPainter customPainter = getCustomPainter();

  // @override
  // CustomPainter Function() getCustomPainter =  ;

  @override
  String Function() get elementText {
    return () {
      switch (relationshipType?.name) {
        case 'Association':
          return '─────';
        case 'Dependency':
          return '─ ─ ─►';
        case 'Generalization':
          return '────►';
        case 'Extend':
          return '──Ext──';
        case 'Include':
          return '──Inc──';
        default:
          return '─────';
      }
    };
  }

  @override
  LinePainter Function() get customPainter {
    return () {
      switch (relationshipType?.name) {
        case 'Association':
          LinePainter painter = AssociationPainter(
              start: start!,
              end: end!,
              sizeStart: objectStart?.size ?? const Size(100, 100),
              sizeEnd: objectEnd?.size ?? const Size(100, 100),
              heightOffset: y ?? 0.0,
              text: name ?? '');
          painter.calculateCoordinates();
          start = painter.getStart;
          end = painter.getEnd;
          return painter;
        case 'Dependency':
          LinePainter painter = DependencyPainter(
              start: start!,
              end: end!,
              sizeStart: objectStart?.size ?? const Size(100, 100),
              sizeEnd: objectEnd?.size ?? const Size(100, 100),
              heightOffset: y ?? 0.0,
              text: name ?? '');
          painter.calculateCoordinates();
          start = painter.getStart;
          end = painter.getEnd;
          return painter;
        case 'Generalization':
          LinePainter painter = GeneralizationPainter(
              start: start!,
              end: end!,
              sizeStart: objectStart?.size ?? const Size(100, 100),
              sizeEnd: objectEnd?.size ?? const Size(100, 100),
              heightOffset: y ?? 0.0,
              text: name ?? '');
          painter.calculateCoordinates();
          start = painter.getStart;
          end = painter.getEnd;
          return painter;
        case 'Include':
          LinePainter painter = DependencyPainter(
              start: start!,
              end: end!,
              sizeStart: objectStart?.size ?? const Size(100, 100),
              sizeEnd: objectEnd?.size ?? const Size(100, 100),
              heightOffset: y ?? 0.0,
              text: '<<include>>');
          painter.calculateCoordinates();
          start = painter.getStart;
          end = painter.getEnd;
          return painter;
        case 'Extend':
          LinePainter painter = DependencyPainter(
              start: start!,
              end: end!,
              sizeStart: objectStart?.size ?? const Size(100, 100),
              sizeEnd: objectEnd?.size ?? const Size(100, 100),
              heightOffset: y ?? 0.0,
              text: '<<extend>>');
          painter.calculateCoordinates();
          start = painter.getStart;
          end = painter.getEnd;
          return painter;
        default:
          LinePainter painter = DependencyPainter(
              // color: Colors.green,
              start: start!,
              end: end!,
              sizeStart: objectStart?.size ?? const Size(100, 100),
              sizeEnd: objectEnd?.size ?? const Size(100, 100),
              heightOffset: y ?? 0.0,
              text: '');
          print("Old size: ${objectStart?.size}");
          objectStart?.position = painter.getStart;
          print("New size: ${objectStart?.size}");
          objectEnd?.position = painter.getEnd;
          return painter;
      }
    };
  }

  // @override
  // bool get leftCheckboxValue => objectStart != null;

  // @override
  // bool get rightCheckboxValue => objectEnd != null;

//   @override
//   set leftCheckboxValue(bool value) {
//     objectStart = value ? objectStart : null;
//   }
//   @override
//   set rightCheckboxValue(bool value) {
//     objectEnd = value ? objectEnd : null;
//   }
// }

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

  // @override
  // set start(Offset? start) {
  //   super.start = start;
  // }

  // @override
  // set end(Offset? end) {
  //   super.end = end;
  // }

  //   @override
  // set sssa(Size? newSize) {
  //   dimension = newSize!.height;
  //       print("$dimension new");

  // }

  @override
  String get getName => name ?? '';
  
}
