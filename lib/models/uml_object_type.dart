class ObjectType {
  final int? id;
  final String? name;

  ObjectType({
    this.id,
    this.name,
  });

  factory ObjectType.fromJson(Map<String, dynamic> json) {
    return ObjectType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'ObjectType{id: $id, name: $name}';
  }
}