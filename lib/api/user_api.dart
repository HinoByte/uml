import 'package:dio/dio.dart';
import 'package:uml/config.dart';
import 'package:uml/models/user.dart';

final Dio dio = Dio();

class UserApi {
  static Future<List<User>> getUsers() async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/users');
      List jsonResponse = response.data;
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  static Future<User> getUserById(int id) async {
    try {
      final response = await dio.get('${AppConfig.apiUrl}/users/$id');
      return User.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to load user by ID: $e');
    }
  }

  static Future<User> createUser(User user) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}/users',
        data: user.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return User.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  static Future<User> updateUser(User user) async {
    try {
      final response = await dio.put(
        '${AppConfig.apiUrl}/users/${user.id}',
        data: user.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return User.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  static Future<void> deleteUser(int id) async {
    try {
      await dio.delete('${AppConfig.apiUrl}/users/$id');
    } on DioError catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  static Future<User> login(String username, String password) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      return User.fromJson(response.data);
    } on DioError {
      rethrow;
    }
  }
}
