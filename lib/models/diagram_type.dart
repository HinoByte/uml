class DiagramType {
  final int? id;
  final String? name;

  DiagramType({
    this.id,
    this.name,
  });

  factory DiagramType.fromJson(Map<String, dynamic> json) {
    return DiagramType(
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
    return 'DiagramType{id: $id, name: $name}';
  }
}