import 'package:dio/dio.dart';
import 'package:uml/config.dart';
import 'package:uml/models/diagram_type.dart';

final Dio dio = Dio();

class DiagramTypesApi {
  static Future<List<DiagramType>> getDiagramTypes() async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/diagramtypes');
      List jsonResponse = response.data;
      return jsonResponse.map((diagramType) => DiagramType.fromJson(diagramType)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to load diagram types: $e');
    }
  }

  static Future<DiagramType> getDiagramTypeById(int id) async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/diagramtypes/$id');
      return DiagramType.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to load diagram type by ID: $e');
    }
  }

  static Future<DiagramType> createDiagramType(DiagramType diagramType) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}/diagramtypes',
        data: diagramType.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return DiagramType.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to create diagram type: $e');
    }
  }

  static Future<DiagramType> updateDiagramType(DiagramType diagramType) async {
    try {
      final response = await dio.put(
        '${AppConfig.apiUrl}/diagramtypes/${diagramType.id}',
        data: diagramType.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return DiagramType.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to update diagram type: $e');
    }
  }

  static Future<void> deleteDiagramType(int id) async {
    try {
      await dio.delete('${AppConfig.apiUrl}/diagramtypes/$id');
    } on DioError catch (e) {
      throw Exception('Failed to delete diagram type: $e');
    }
  }
}