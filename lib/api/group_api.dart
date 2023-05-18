import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uml/config.dart';
import 'package:uml/models/group.dart';

final Dio dio = Dio();

class GroupApi {
  static Future<List<Group>> getGroups() async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/groups');
      List jsonResponse = response.data;
      return jsonResponse.map((group) => Group.fromJson(group)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to load groups: $e');
    }
  }

  static Future<Group> getGroupById(int id) async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/groups/$id');
      return Group.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to load group by ID: $e');
    }
  }

  static Future<Group> createGroup(Group group) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}/groups',
        data: json.encode(group.toJson()),
        options: Options(contentType: Headers.jsonContentType),
      );
      print(response.data);
      return Group.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to create group: $e');
    }
  }

  static Future<Group> updateGroup(Group group) async {
    try {
      final response = await dio.put(
        '${AppConfig.apiUrl}/groups/${group.id}',
        data: json.encode(group.toJson()),
        options: Options(contentType: Headers.jsonContentType),
      );
      return Group.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to update group: $e');
    }
  }

  static Future<void> deleteGroup(int id) async {
    try {
      await dio.delete('${AppConfig.apiUrl}/groups/$id');
    } on DioError catch (e) {
      throw Exception('Failed to delete group: $e');
    }
  }
}
