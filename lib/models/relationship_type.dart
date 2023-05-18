class RelationshipType {
  final int? id;
  final String? name;

  RelationshipType({
    this.id,
    this.name,
  });

  factory RelationshipType.fromJson(Map<String, dynamic> json) {
    return RelationshipType(
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
    return 'RelationshipType{id: $id, name: $name}';
  }
}
