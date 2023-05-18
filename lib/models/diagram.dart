import 'package:uml/models/diagram_type.dart';
import 'package:uml/models/user.dart';
import 'package:uml/utils/base_entity.dart';

class Diagram extends BaseEntity{
  final int? id;
  final User? user;
  final DiagramType? diagramType;
  final Diagram? parentObject;
  final String? name;
  final DateTime? data;

  Diagram({
    this.id,
    this.user,
    this.diagramType,
    this.parentObject,
    this.name,
    this.data,
  });

  factory Diagram.fromJson(Map<String, dynamic> json) {
    return Diagram(
      id: json['id'],
      user: json['user'] == null ? null : User.fromJson(json['user']),
      diagramType: json['diagram_type'] == null
          ? null
          : DiagramType.fromJson(json['diagram_type']),
      parentObject: json['parent_object'] == null
          ? null
          : Diagram.fromJson(json['parent_object']),
      name: json['name'],
      data: json['data'] == null ? null : DateTime.parse(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'diagram_type': diagramType?.toJson(),
      'parent_object': parentObject?.toJson(),
      'name': name,
      'data': data?.toIso8601String(),
    };
  }
  
 @override
  String get getName => name ?? '';

  @override
  String toString() {
    return 'Diagram{id: $id, user: $user, diagramType: $diagramType, parentObject: $parentObject, name: $name, data: $data}';
  }
}
