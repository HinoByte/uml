import 'package:dio/dio.dart';
import 'package:uml/config.dart';
import 'package:uml/models/diagram.dart';

final Dio dio = Dio();

class DiagramApi {
  static Future<List<Diagram>> getDiagrams() async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/diagrams');
      List jsonResponse = response.data;
      return jsonResponse.map((diagram) => Diagram.fromJson(diagram)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to load diagrams: $e');
    }
  }

  static Future<Diagram> getDiagramById(int id) async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/diagrams/$id');
      return Diagram.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to load diagram by ID: $e');
    }
  }

  static Future<Diagram> createDiagram(Diagram diagram) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}/diagrams',
        data: diagram.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return Diagram.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to create diagram: $e');
    }
  }

  static Future<Diagram> updateDiagram(Diagram diagram) async {
    try {
      final response = await dio.put(
        '${AppConfig.apiUrl}/diagrams/${diagram.id}',
        data: diagram.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return Diagram.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to update diagram: $e');
    }
  }

  static Future<void> deleteDiagram(int id) async {
    try {
      await dio.delete('${AppConfig.apiUrl}/diagrams/$id');
    } on DioError catch (e) {
      throw Exception('Failed to delete diagram: $e');
    }
  }
}