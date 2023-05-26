
class Group  {
  final int? id;
  final String? name;
  final String? kafedra;
  final int? year;

  Group({this.id, this.name, required this.kafedra, this.year});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      kafedra: json['kafedra'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kafedra': kafedra,
      'year': year,
    };
  }

  
  String get getName => name ?? kafedra ?? '';

  @override
  String toString() {
    return 'Group{id: $id, name: $name, kafedra: $kafedra, year: $year}';
  }
}
