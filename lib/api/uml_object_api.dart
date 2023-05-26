import 'package:dio/dio.dart';
import 'package:uml/config.dart';
import 'package:uml/models/uml_object.dart';

final Dio dio = Dio();

class UmlObjectApi {
  static Future<List<UmlObject>> getUmlObjects() async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/objects');
      List jsonResponse = response.data;
      return jsonResponse.map((umlObject) => UmlObject.fromJson(umlObject)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to load UML objects: $e');
    }
  }

  static Future<UmlObject> getUmlObjectById(int id) async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/objects/$id');
      return UmlObject.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to load UML object by ID: $e');
    }
  }

  static Future<UmlObject> createUmlObject(UmlObject umlObject) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}/objects',
        data: umlObject.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return UmlObject.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to create UML object: $e');
    }
  }

  static Future<UmlObject> updateUmlObject(UmlObject umlObject) async {
    try {
      final response = await dio.put(
        '${AppConfig.apiUrl}/objects/${umlObject.id}',
        data: umlObject.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return UmlObject.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to update UML object: $e');
    }
  }

  static Future<void> deleteUmlObject(int id) async {
    try {
      await dio.delete('${AppConfig.apiUrl}/objects/$id');
    } on DioError catch (e) {
      throw Exception('Failed to delete UML object: $e');
    }
  }
}