import 'package:dio/dio.dart';
import 'package:uml/api/diagram_api.dart';
import 'package:uml/config.dart';
import 'package:uml/models/relationship.dart';

class RelationshipApi {
  static Future<List<Relationship>> getRelationships() async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/relationships');
      List jsonResponse = response.data;
      return jsonResponse.map((relationship) => Relationship.fromJson(relationship)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to load relationships: $e');
    }
  }

  static Future<List<Relationship>>getRelationshipsByDiagramId(int id) async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/relationships/$id');
      List jsonResponse = response.data;
      return jsonResponse.map((relationship) => Relationship.fromJson(relationship)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to load relationship by ID: $e');
    }
  }

  static Future<Relationship> createRelationship(Relationship relationship) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}/relationships',
        data: relationship.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return Relationship.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to create relationship: $e');
    }
  }

  static Future<Relationship> updateRelationship(Relationship relationship) async {
    try {
      final response = await dio.put(
        '${AppConfig.apiUrl}/relationships/${relationship.id}',
        data: relationship.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return Relationship.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to update relationship: $e');
    }
  }

  static Future<void> deleteRelationship(int id) async {
    try {
      await dio.delete('${AppConfig.apiUrl}/relationships/$id');
    } on DioError catch (e) {
      throw Exception('Failed to delete relationship: $e');
    }
  }
}