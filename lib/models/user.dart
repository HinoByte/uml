import 'package:uml/models/group.dart';

class User {
  final int? id;
  final Group? group;
  final String? name;
  final String? username;
  final String? password;

  User({
    this.id,
    this.group,
    this.name,
    this.username,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      group: json['group'] == null ? null : Group.fromJson(json['group']),
      name: json['name'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group': group?.toJson(),
      'name': name,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, group: $group, name: $name, username: $username, password: $password}';
  }
}
