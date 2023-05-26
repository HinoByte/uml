import 'package:dio/dio.dart';
import 'package:uml/api/user_api.dart';
import 'package:uml/utils/error_type.dart';
import 'package:uml/models/user.dart';
import 'package:dartz/dartz.dart';

enum UserRole { student, teacher, administrator }

class UserRepository {
  static final UserRepository instance = UserRepository._privateConstructor();
  UserRepository._privateConstructor();

  User? _currentUser;
  UserRole _userRole = UserRole.student;

  User? get currentUser => _currentUser;
  UserRole get userRole => _userRole;


  String get role {
  switch (_userRole) {
    case UserRole.student:
      return 'Студент';
    case UserRole.teacher:
      return 'Преподаватель';
    case UserRole.administrator:
      return 'Администратор';
    default:
      return 'Неизвестная роль';
  }
}

  Future<Either<ErrorType, User>> login(
      String username, String password) async {
    try {
      final user = await UserApi.login(username, password);
      _currentUser = user;
      if (user.group == null) {
        _userRole = UserRole.administrator;
      } else if (user.group!.name == null) {
        _userRole = UserRole.teacher;
      } else {
        _userRole = UserRole.student;
      }
      return right(user);
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 403) {
        return left(ErrorType(
            code: e.response?.statusCode ?? 0,
            message: 'Неверный пользователь или пароль'));
      } else {
        return left(ErrorType(code: 0, message: 'Ошибка: ${e.toString()}'));
      }
    }
  }
}
