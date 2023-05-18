import 'package:flutter/material.dart';
import 'package:uml/models/relationship_type.dart';
import 'package:uml/utils/connections.dart';
import 'package:uml/utils/visual_object.dart';
import 'package:uml/widgets/painters/relationships_painters/association_painter.dart';
import 'package:uml/widgets/painters/relationships_painters/dependency_painter.dart';

class Relationship extends Connection implements IVisualObject {
  final int? id;
  final int? startId;
  final int? endId;
  final RelationshipType? relationshipType;
  final String? description;
  final int? y;

  Relationship({
    this.id,
    this.startId,
    this.endId,
    this.relationshipType,
    this.description,
    this.y,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      id: json['id'],
      startId: json['start_id'],
      endId: json['end_id'],
      relationshipType: json['relationship_type'] == null
          ? null
          : RelationshipType.fromJson(json['relationship_type']),
      description: json['description'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_id': startId,
      'end_id': endId,
      'relationship_type': relationshipType,
      'description': description,
      'y': y,
    };
  }

  @override
  String toString() {
    return 'Relationship{startId: $startId, endId: $endId, relationshipType: $relationshipType, description: $description, y: $y}';
  }

  @override
  Offset position = const Offset(150, 150);

  // @override
  // CustomPainter customPainter = getCustomPainter();

  // @override
  // CustomPainter Function() getCustomPainter =  ;
  @override
  CustomPainter Function() get customPainter {
    return () {
      switch (relationshipType?.name) {
        case 'Association':
          return AssociationPainter();
        // case 'Generalization':
        //   return GeneralizationPainter();
        case 'Dependency':
          return DependencyPainter('dependency');
        case 'Include':
          return DependencyPainter('include');
        // case 'Extend':
        //   return ExtendPainter();
        default:
          return DependencyPainter('dependency'); // вернуть стандартный Painter, если другие не подходят
      }
    };
  }

  @override
  set customPainter(CustomPainter Function() customPainter) {}

}
