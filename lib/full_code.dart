import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
class AppConfig {
  static const String apiUrl = 'http://192.168.1.239:8787';
}


void main() {
  // GoogleFonts.config.allowRuntimeFetching = false;
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.dark,
          //primaryColor: Colors.red,
          // accentColor: Colors.red,

          // Define the default font family.
          // fontFamily: 'Georgia',

          // // Define the default TextTheme. Use this to specify the default
          // // text styling for headlines, titles, bodies of text, and more.
          // textTheme: TextTheme(
          //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          // ),
          ),
      home: Scaffold(
        body:
          // LoginPage(),
        UseCasePage(diagram: Diagram(name: 'sadads'),
        
        
        
        ),
      ),
    );
  }
}


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



class Diagram extends BaseEntity{
  final int? id;
  final User? user;
  final DiagramType? diagramType;
  final Diagram? parentObject;
  final String? name;
  final DateTime? data;

  Diagram({
    this.id,
    this.user,
    this.diagramType,
    this.parentObject,
    this.name,
    this.data,
  });

  factory Diagram.fromJson(Map<String, dynamic> json) {
    return Diagram(
      id: json['id'],
      user: json['user'] == null ? null : User.fromJson(json['user']),
      diagramType: json['diagram_type'] == null
          ? null
          : DiagramType.fromJson(json['diagram_type']),
      parentObject: json['parent_object'] == null
          ? null
          : Diagram.fromJson(json['parent_object']),
      name: json['name'],
      data: json['data'] == null ? null : DateTime.parse(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'diagram_type': diagramType?.toJson(),
      'parent_object': parentObject?.toJson(),
      'name': name,
      'data': data?.toIso8601String(),
    };
  }
  
 @override
  String get getName => name ?? '';

  @override
  String toString() {
    return 'Diagram{id: $id, user: $user, diagramType: $diagramType, parentObject: $parentObject, name: $name, data: $data}';
  }
}



class Group extends BaseEntity {
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

  @override
  String get getName => name ?? kafedra ?? '';

  @override
  String toString() {
    return 'Group{id: $id, name: $name, kafedra: $kafedra, year: $year}';
  }
}



class Relationship extends Connection implements IVisualObject {
  final int? id;
  final int? startId;
  final int? endId;
  final RelationshipType? relationshipType;
  final String? description;
  final int? y;

  Relationship({
    this.id,
    this.startId,
    this.endId,
    this.relationshipType,
    this.description,
    this.y,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      id: json['id'],
      startId: json['start_id'],
      endId: json['end_id'],
      relationshipType: json['relationship_type'] == null
          ? null
          : RelationshipType.fromJson(json['relationship_type']),
      description: json['description'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_id': startId,
      'end_id': endId,
      'relationship_type': relationshipType,
      'description': description,
      'y': y,
    };
  }

  @override
  String toString() {
    return 'Relationship{startId: $startId, endId: $endId, relationshipType: $relationshipType, description: $description, y: $y}';
  }

  @override
  Offset position = const Offset(150, 150);

  // @override
  // CustomPainter customPainter = getCustomPainter();

  // @override
  // CustomPainter Function() getCustomPainter =  ;
  @override
  CustomPainter Function() get customPainter {
    return () {
      switch (relationshipType?.name) {
        case 'Association':
          return AssociationPainter();
        // case 'Generalization':
        //   return GeneralizationPainter();
        case 'Dependency':
          return DependencyPainter('dependency');
        case 'Include':
          return DependencyPainter('include');
        // case 'Extend':
        //   return ExtendPainter();
        default:
          return DependencyPainter('dependency'); // вернуть стандартный Painter, если другие не подходят
      }
    };
  }

  @override
  set customPainter(CustomPainter Function() customPainter) {}

}


class ObjectType {
  final int? id;
  final String? name;

  ObjectType({
    this.id,
    this.name,
  });

  factory ObjectType.fromJson(Map<String, dynamic> json) {
    return ObjectType(
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
    return 'ObjectType{id: $id, name: $name}';
  }
}


class UmlObject extends Entity implements IVisualObject {
  final int? id;
  final int? diagramId;
  final String? name;
  final ObjectType? objectType;
  final double? x;
  final double? y;

  UmlObject({
    this.id,
    this.diagramId,
    this.name,
    this.objectType,
    this.x,
    this.y,
  });

  factory UmlObject.fromJson(Map<String, dynamic> json) {
    return UmlObject(
      id: json['id'],
      diagramId: json['diagram_id'],
      name: json['name'],
      objectType: json['object_type'] == null
          ? null
          : ObjectType.fromJson(json['object_type']),
      x: json['X'],
      y: json['Y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diagram_id': diagramId,
      'name': name,
      'object_type': objectType,
      'X': x,
      'Y': y,
    };
  }

  @override
  String toString() {
    return 'UmlObject{diagramId: $diagramId, name: $name, objectType: $objectType, X: $x, Y: $y}';
  }

  @override
  Offset position = const Offset(300, 300);

  @override
  CustomPainter Function() get customPainter {
    return () {
      switch (objectType?.name) {
        case 'Actor':
          return ActorPainter();
        case 'UseCase':
          return PrecedentPainter();
        case 'Boundary':
          return PrecedentPainter();
        default:
          return ActorPainter(); 
      }
    };
  }

  @override
  set customPainter(CustomPainter Function() customPainter) {}
}


class RelationshipType {
  final int? id;
  final String? name;

  RelationshipType({
    this.id,
    this.name,
  });

  factory RelationshipType.fromJson(Map<String, dynamic> json) {
    return RelationshipType(
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
    return 'RelationshipType{id: $id, name: $name}';
  }
}


class Connection {
  bool leftCheckboxValue;
  bool rightCheckboxValue;

  Connection({this.leftCheckboxValue = false, this.rightCheckboxValue = false});

  bool get isArrowConnected => leftCheckboxValue && rightCheckboxValue;
}


class Entity {
  bool selectCheckboxValue;

  Entity({this.selectCheckboxValue = false});
}


abstract class BaseEntity {
  String get getName;
}


abstract class IVisualObject {

  CustomPainter Function() customPainter;

  Offset position; 


  IVisualObject({required this.customPainter,required this.position});
}


class ErrorType {
  final int code;
  final String message;

  ErrorType({required this.code, required this.message});
}


class PasswordField extends StatefulWidget {
  const PasswordField({Key? key, required this.controller, this.isReg = false})
      : super(key: key);
  final bool isReg;
  final TextEditingController controller;

  @override
  State<StatefulWidget> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool isObscure = true;

  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController = widget.controller;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(primaryColor: Colors.red),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff80a6ff),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          controller: _passwordController,
          style: GoogleFonts.roboto(fontSize: 18),
          cursorColor: Colors.red,
          obscureText: !isObscure,
          decoration: InputDecoration(
            icon: const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Icon(
                Icons.lock,
                color: Color(0xfff8f8f8),
              ),
            ),
            labelText: 'ПАРОЛЬ',
            hintText: widget.isReg ? 'Минимум 6 символов' : '',
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Icon(
                  Icons.visibility,
                  color: Color(isObscure ? 0xFFFFFFFF : 0xFF000000),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class ValueDropdown<T extends BaseEntity> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final ValueChanged<T?> onChanged;
  final String labelText;
  final IconData iconData;

  const ValueDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.labelText,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff80a6ff),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.only(left: 15.0),
      child: InputDecorator(
        decoration: InputDecoration(
          icon: Icon(
            iconData,
            color: const Color(0xfff8f8f8),
          ),
          labelText: labelText,
          labelStyle: GoogleFonts.roboto(fontSize: 18),
          border: InputBorder.none,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            dropdownColor: const Color(0xff80a6ff),
            hint: Text(
              labelText,
              style: GoogleFonts.lobster(fontSize: 18),
            ),
            value: selectedItem,
            items: items.map<DropdownMenuItem<T>>((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.getName,
                  style: GoogleFonts.lobster(fontSize: 18),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}



class MessageDialog extends StatelessWidget {
  final String title;
  final String message;

  const MessageDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}



class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    IconData roleIcon;
    String roleString;
    switch (UserRepository.instance.userRole) {
      case UserRole.student:
        roleIcon = Icons.school;
        roleString = 'Студент';
        break;
      case UserRole.teacher:
        roleIcon = Icons.menu_book;
        roleString = 'Преподаватель';
        break;
      case UserRole.administrator:
        roleIcon = Icons.admin_panel_settings;
        roleString = 'Администратор';
        break;
      default:
        roleIcon = Icons.help;
        roleString = 'Неизвестная роль';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildInfo(
          iconData: Icons.person_outline,
          textData: UserRepository.instance.currentUser?.username ??
              'Default Username',
        ),
        _buildInfo(
          iconData: Icons.account_box_outlined,
          textData: UserRepository.instance.currentUser?.name ?? 'Default Name',
        ),
        _buildInfo(
          iconData: roleIcon,
          textData: roleString,
        ),
      ],
    );
  }

  Widget _buildInfo({
    required IconData iconData,
    required String textData,
  }) {
    return Container(
      height: 45,
      width: 270,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        color: const Color(0xfff8f8f8),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 5),
          Icon(iconData),
          Expanded(
            child: Text(
              textData,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}



class ActionsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double containerWidth;
  final double containerHeight;
  final String buttonText;
  final Color colorBox;

  const ActionsButton({
    Key? key,
    required this.onPressed,
    required this.containerWidth,
    required this.containerHeight,
    required this.buttonText,
    required this.colorBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        color: colorBox,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}


import 'dart:ui';


class DependencyPainter extends CustomPainter {
  final String text;
  // final Offset? start;
  // final Offset? end;

  DependencyPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Начальная точка
    path.moveTo(0, 0);

    // Прерывистая линия
    for (int i = 10; i < size.width.toInt(); i += 20) {
      path.lineTo(i.toDouble(), 0);
      path.moveTo(i.toDouble() + 10, 0);
    }

    // Стрелка на конце
    path.moveTo(size.width - 10, -5);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 10, 5);

    canvas.drawPath(path, paint);

    final paragraphStyle = ParagraphStyle(
      textAlign: TextAlign.center,
      maxLines: 1,
    );
    final paragraphBuilder = ParagraphBuilder(paragraphStyle)
      // ..pushStyle(TextStyle(color: Colors.black, fontSize: 16.0))  // Добавляем черный цвет текста
      ..addText(text);

    final paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: size.width));

    // Центрируем текст по горизонтали и вертикали
    final offset = Offset(size.width / 2 - paragraph.width / 2, size.height / 2 - paragraph.height / 2);

    canvas.drawParagraph(paragraph, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class AssociationPainter extends CustomPainter {
  final Offset? start;
  final Offset? end;

  AssociationPainter({this.start, this.end});

  List<Offset> edgeCenters(Rect rect) {
    return [
      Offset(rect.left, rect.center.dy),
      Offset(rect.right, rect.center.dy),
      Offset(rect.center.dx, rect.top),
      Offset(rect.center.dx, rect.bottom),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    int objectCount = (start != null ? 1 : 0) + (end != null ? 1 : 0);

    if (objectCount == 0) {
      // Начальная точка на левой границе области рисования
      Offset lineStart = Offset(0, size.height / 2);

      // Конечная точка на правой границе области рисования
      Offset lineEnd = Offset(size.width, size.height / 2);

      // Рисуем линию
      canvas.drawLine(lineStart, lineEnd, paint);
    } else if (objectCount == 1) {
      final objectRect1 = Rect.fromLTWH(start!.dx, start!.dy, 100, 100);
              canvas.drawRect(objectRect1, paint);

      var points1 = edgeCenters(objectRect1);

      var line = points1.map((p1) => MapEntry(p1, end)).reduce(
          (value, element) => (value.key - value.value!).distance <
                  (element.key - element.value!).distance
              ? value
              : element);

      canvas.drawLine(line.key, line.value!, paint);
    } else if (objectCount == 2) {
      final objectRect1 = Rect.fromLTWH(start!.dx, start!.dy, 100, 100);
      final objectRect2 = Rect.fromLTWH(end!.dx, end!.dy, 100, 100);
      var points1 = edgeCenters(objectRect1);
      var points2 = edgeCenters(objectRect2);

      var line = points1
          .expand((p1) => points2.map((p2) => MapEntry(p1, p2)))
          .reduce((value, element) => (value.key - value.value).distance <
                  (element.key - element.value).distance
              ? value
              : element);

      canvas.drawLine(line.key, line.value, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


// class LinePainter extends CustomPainter {
//   final Offset start;
//   final Offset end;

//   LinePainter({required this.start, required this.end});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 2.0;

//     canvas.drawLine(start, end, paint);
//   }

//   // @override
//   // bool shouldRepaint(LinePainter oldDelegate) {
//   //   print(start);
//   //   return oldDelegate.start != start || oldDelegate.end != end;
//   // }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }



class ActorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Рисуем голову
    canvas.drawCircle(Offset(center.dx, center.dy - size.height / 4), size.width / 4, paint);

    // Рисуем туловище
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx, center.dy + size.height / 4),
      paint,
    );

    // Рисуем руки
    canvas.drawLine(
      Offset(center.dx, center.dy + size.height / 8),
      Offset(center.dx - size.width / 4, center.dy + size.height / 8),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + size.height / 8),
      Offset(center.dx + size.width / 4, center.dy + size.height / 8),
      paint,
    );

    // Рисуем ноги
    canvas.drawLine(
      Offset(center.dx, center.dy + size.height / 4),
      Offset(center.dx - size.width / 4, center.dy + size.height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + size.height / 4),
      Offset(center.dx + size.width / 4, center.dy + size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class PrecedentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Рисуем овал
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: size.height * 0.6,
    );
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


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

  // Методы для других операций, таких как регистрация, выход и т.д.
}



class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<User> _users = [];
  List<User> _usersFiltered = [];
  List<Group> _groups = [];
  // int _selectedYear = 2023;
  // String _selectedName = '';
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    List<User> users = await UserApi.getUsers();
    List<Group> groups = await GroupApi.getGroups();
    _users = users;
    setState(() {
      _usersFiltered = _getFilteredAndSortedUsers();
      _groups = groups;
    });
    // print(_users);
    // print(_usersFiltered);
    // _selectedYear = _getGroupsYears()
    // .first; // Set the first year available as the default
    // _selectedGroup = _groups.firstWhere((group) =>
    //     group.year ==
    //     _selectedYear); // Set the first group of the selected year as the default
  }

  // List<int> _getGroupsYears() {
  //   return _groups.map((group) => group.year).toSet().toList()..sort();
  // }

  // List<Group> _getFilteredGroups() {
  //   return _groups.where((group) => group.year == _selectedYear).toList();
  // }

  // List<User> _getFilteredUsers() {
  //   return _users.where((user) => user.group?.id == _selectedGroup).toList();
  // }
  List<User> _getFilteredAndSortedUsers() {
    return _users
        .where((user) =>
            (user.group?.name != null || user.group?.kafedra != null) &&
            user.name!.isNotEmpty)
        .toList()
      ..sort((a, b) => a.name!.compareTo(b.name!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            colors: [
              Color(0xff80a6ff),
              Color.fromARGB(239, 128, 166, 255),
              Color.fromARGB(222, 128, 166, 255),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                    offset: const Offset(-10, 10),
                    child: ActionsButton(
                      buttonText: 'ВЫЙТИ',
                      containerWidth: 450,
                      containerHeight: 50,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      colorBox: const Color.fromARGB(255, 255, 128, 128),
                    )),
              ],
            ),
            //        Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     DropdownButton<int>(
            //       hint: Text('Select Year'),
            //       value: ,
            //       items: _getGroupsYears()
            //           .map<DropdownMenuItem<int>>((int value) {
            //             return DropdownMenuItem<int>(
            //               value: value,
            //               child: Text(value.toString()),
            //             );
            //           }).toList(),
            //       onChanged: (int? newValue) {
            //         setState(() {
            //           _selectedYear = newValue!;
            //           _selectedName = _getFilteredGroups().first.name; // Set the first group name of the selected year as the default
            //         });
            //       },
            //     ),
            //     DropdownButton<String>(
            //       hint: Text('Select Group'),
            //       value: _selectedName,
            //       items: _getFilteredGroups()
            //           .map<DropdownMenuItem<String>>((Group group) {
            //             return DropdownMenuItem<String>(
            //               value: group.name,
            //               child: Text(group.name),
            //             );
            //           }).toList(),
            //       onChanged: (String? newValue) {
            //         setState(() {
            //           _selectedName = newValue!;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            SizedBox(
              width: 690,
              child: Column(
                children: [
                  UserRepository.instance.userRole == UserRole.administrator
                      ? _buidAdminButtons()
                      : Container(),
                  //_buidAdminButtons(),
                  const SizedBox(
                    height: 35,
                  ),
                  _buildUsers(),
                ],
              ),
            ),
            const UserInfo(),
          ],
        ),
      ),
    );
  }

  Row _buidAdminButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ActionsButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Выберите действие',
                    textAlign: TextAlign.center,
                  ),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Вы хотите добавить пользователя или группу?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Добавить пользователя'),
                          onPressed: () {
                            _openUserEditPage();
                          },
                        ),
                        TextButton(
                          child: const Text('Добавить группу'),
                          onPressed: () {
                            _openGroupAddPage();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          containerWidth: 200.0,
          containerHeight: 45.0,
          buttonText: 'ДОБАВИТЬ',
          colorBox: const Color(0xff80ff8c),
        ),
        ActionsButton(
          onPressed: () {
            if (_selectedIndex != null) {
              _openUserEditPage(user: _usersFiltered[_selectedIndex!]);
            } else {
              showDialog(
                context: context,
                builder: (context) => const MessageDialog(
                  title: 'Уведомление',
                  message: 'Выберите пользователя для изменения',
                ),
              );
            }
          },
          containerWidth: 200.0,
          containerHeight: 45.0,
          buttonText: 'ИЗМЕНИТЬ',
          colorBox: const Color(0xffffbd80),
        ),
        ActionsButton(
          onPressed: () {
            if (_selectedIndex != null) {
              UserApi.deleteUser(_usersFiltered[_selectedIndex!].id!).then((_) {
                showDialog(
                  context: context,
                  builder: (context) => const MessageDialog(
                    title: 'Успех!',
                    message: 'Пользователь успешно удален',
                  ),
                );
                _fetchData();
              }).catchError((error) {
                showDialog(
                  context: context,
                  builder: (context) => MessageDialog(
                    title: 'Ошибка удаления пользователя',
                    message: error.toString(),
                  ),
                );
              });
            } else {
              showDialog(
                context: context,
                builder: (context) => const MessageDialog(
                  title: 'Уведомление',
                  message: 'Выберите пользователя для удаления',
                ),
              );
            }
          },
          containerWidth: 200.0,
          containerHeight: 45.0,
          buttonText: 'УДАЛИТЬ',
          colorBox: const Color(0xffff8080),
        ),
      ],
    );
  }

  Container _buildUsers() {
    return Container(
      height: 250,
      width: 690,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.separated(
        itemCount: _usersFiltered.length,
        itemBuilder: (BuildContext context, int index) {
          User user = _usersFiltered[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = _selectedIndex == index ? null : index;
              });
            },
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color:
                    index == _selectedIndex ? Colors.grey[300] : Colors.white,
                border: Border.all(
                  color: index == _selectedIndex
                      ? Colors.black
                      : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        user.name!,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        user.group?.name != null
                            ? 'Обучающийся'
                            : 'Преподаватель',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        user.group?.name ?? user.group!.kafedra ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  void _openUserEditPage({User? user}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserEditPage(
          user: user,
          isCreating: user == null,
          groups: _groups,
        ),
      ),
    ).then((_) {
      if (user == null) {
        Navigator.of(context).pop();
        _selectedIndex = null;
      }
      _fetchData();
    });
  }

  void _openGroupAddPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GroupAddPage(),
      ),
    ).then((_) {
      Navigator.of(context).pop();
      _fetchData();
    });
  }
}



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            colors: [
              Color(0xff80a6ff),
              Color.fromARGB(239, 128, 166, 255),
              Color.fromARGB(222, 128, 166, 255),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(0xfff8f8f8),
              ),
              height: 180,
              width: 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff80a6ff),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: GoogleFonts.lobster(fontSize: 18),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.roboto(fontSize: 18),
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Icon(
                              Icons.alternate_email,
                              color: Color(0xfff8f8f8),
                            ),
                          ),
                          labelText: 'ИМЯ ПОЛЬЗОВАТЕЛЯ',
                          hintText: 'Иванов И. И.',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 0, bottom: 20),
                    child: PasswordField(
                      controller: _passwordController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ActionsButton(
              onPressed: () {
                UserRepository.instance
                    .login(_nameController.text, _passwordController.text)
                    .then((result) {
                  result.fold(
                    (error) {
                      showDialog(
                        context: context,
                        builder: (context) => MessageDialog(
                            title: 'Ошибка аутентификации',
                            message: error.message),
                      );
                    },
                    (user) {
                      UserRole? currentUserRole =
                          UserRepository.instance.userRole;
                      if (currentUserRole == UserRole.student) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const VariantPage()));
                      } else {
                        print(user);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const StudentPage()));
                      }
                    },
                  );
                });
              },
              containerWidth: 450.0,
              containerHeight: 50.0,
              buttonText: 'ВОЙТИ',
              colorBox: const Color.fromARGB(255, 128, 255, 141),
            ),
          ],
        ),
      ),
    );
  }
}



class UseCasePage extends StatefulWidget {
  final Diagram diagram;

  const UseCasePage({Key? key, required this.diagram}) : super(key: key);

  @override
  _UseCasePageState createState() => _UseCasePageState();
}

class _UseCasePageState extends State<UseCasePage> {
  List<IVisualObject> visualObjects = [
    UmlObject()..position = const Offset(0, 0),
    UmlObject()..position = const Offset(150, 150),
    Relationship()..position = const Offset(150, 150),
  ];

  final stackKey = GlobalKey();
  Relationship? activeConnection;


  // List<CustomSquare> squares = [CustomSquare(position: const Offset(100, 100))];
  // Offset off = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          colors: [
            Color(0xff80a6ff),
            Color.fromARGB(239, 128, 166, 255),
            Color.fromARGB(222, 128, 166, 255),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: 45,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                color: const Color(0xfff8f8f8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                widget.diagram.getName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
            Column(
              children: [
                Transform.translate(
                  offset: const Offset(-10, 10),
                  child: Row(
                    children: [
                      ActionsButton(
                        buttonText: 'СОХРАНИТЬ',
                        containerWidth: 450,
                        containerHeight: 50,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        colorBox: const Color(0xff80ff8c),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ActionsButton(
                        buttonText: 'ВЫЙТИ',
                        containerWidth: 450,
                        containerHeight: 50,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        colorBox: const Color.fromARGB(255, 255, 128, 128),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3f000000),
                          offset: Offset(0, 4),
                          blurRadius: 2.5,
                        ),
                      ],
                    ),
                    height: 50,
                    width: 300,
                    child: Center(
                      child: Text(
                        'РАБОЧИЙ СТОЛ',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Color(0xff55aaff),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.amber,
                    height: screenHeight * 0.77,
                    child: Stack(
                      key: stackKey,
                      children: visualObjects.map((object) {
                        return Positioned(
                          left: object.position.dx,
                          top: object.position.dy,
                          child: Draggable<IVisualObject>(
                            data: object,
                            feedback: Container(
                              // при перемещении
                              color: Colors.black,
                              child: CustomPaint(
                                size: (object is Connection)
                                    ? const Size(10, 10)
                                    : const Size(50, 50),
                                painter: object.customPainter(),
                              ),
                            ),
                            childWhenDragging: Container(),
                            onDragEnd: (DraggableDetails dragDetails) {
                              setState(() {
                                final RenderBox stackBox =
                                    stackKey.currentContext!.findRenderObject()
                                        as RenderBox;
                                final localPosition =
                                    stackBox.globalToLocal(dragDetails.offset);
                                object.position = localPosition;
                              });
                            },
                            child: (object is Connection)
                                ? _drawConnections(object)
                                : _drawEntity(object),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0, 4),
                      blurRadius: 2.5,
                    ),
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(0, 15, 45, 0),
                height: screenHeight * 0.8,
                width: 350,
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    height: 75,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3f000000),
                          offset: Offset(0, 4),
                          blurRadius: 2.5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'ЭЛЕМЕНТЫ ДИАГРАММЫ',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Color(0xff55aaff),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      _buildButtoms(
                          visualObject:
                              UmlObject(objectType: ObjectType(name: 'Actor')),
                          title: 'Actor'),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildButtoms(
                          visualObject: UmlObject(
                              objectType: ObjectType(name: 'UseCase')),
                          title: 'UseCase'),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildButtoms(
                          visualObject: Relationship(
                              relationshipType:
                                  RelationshipType(name: 'Association')),
                          title: 'Association'),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildButtoms(
                          visualObject: Relationship(
                              relationshipType:
                                  RelationshipType(name: 'Dependency')),
                          title: 'Dependency'),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildButtoms(
                          visualObject: Relationship(
                              relationshipType:
                                  RelationshipType(name: 'Dependency')),
                          title: 'Dependency'),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
          const Spacer(),
          const UserInfo(),
        ],
      ),
    ));
  }

  GestureDetector _drawEntity(IVisualObject object) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset localOffset = box.globalToLocal(details.globalPosition);
        print('Позиция нажатия: $localOffset');

        for (var object in visualObjects) {
          if (object is Relationship) {
            var connection = object;
            if ((connection.leftCheckboxValue ||
                    connection.rightCheckboxValue) &&
                !connection.isArrowConnected) {
              activeConnection = connection;
              break;
            }
          }
        }
        print(activeConnection);

        if (activeConnection != null) {
          showDialog(
            context: context,
            builder: (_) => const MessageDialog(
              title: "Подтверждение",
              message: "Вы действительно хотите установить связь?",
            ),
          ).then((_) {
            setState(() {
//               if (activeConnection!.leftCheckboxValue) {
//  (visualObjects[0] as Relationship). = ;


//               }  (visualObjects[0] as Relationship).startId :  (visualObjects[0] as Relationship).endId;
//               activeConnection!.leftCheckboxValue = true;
//               (visualObjects[0] as Relationship).startId;
              // activeConnection = null;
              // activeConnection!.rightCheckboxValue = true;
            });
          });
        }
      },
      child: Container(
        // width: 100,
        // height: 100,
        color: Colors.blue,
        child: CustomPaint(
          size: const Size(100, 100),
          painter: object.customPainter(),
        ),
      ),
    );
  }

  Container _buildButtoms(
      {required IVisualObject visualObject, required String title}) {
    return Container(
      color: Colors.black,
      width: 100,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            visualObjects.add(visualObject);
            // _actors.add(CustomPaint(size: Size(50, 50), painter: ActorPainter()));
          });
        },
        child: Text(title),
      ),
    );
  }

  Widget _drawConnections(IVisualObject object) {
    print(object.position);
    Connection conn = object as Connection;
    return !conn.isArrowConnected
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: (object as Connection).leftCheckboxValue,
                onChanged: (value) {
                  setState(() {
                    (object as Connection).leftCheckboxValue = value!;
                  });
                },
                shape: const CircleBorder(),
              ),
              Container(
                height: 8,
                width: 150,
                color: Colors.blue,
                child: CustomPaint(
                  painter: object.customPainter(),
                ),
              ),
              Checkbox(
                value: (object as Connection).rightCheckboxValue,
                onChanged: (value) {
                  setState(() {
                    (object as Connection).rightCheckboxValue = value!;
                  });
                },
                shape: const CircleBorder(),
              ),
            ],
          )
        : CustomPaint(
            size: Size(50, 50),
            painter: AssociationPainter(
              start: visualObjects[0].position - visualObjects[2].position,
              end: visualObjects[1].position - visualObjects[2].position,
            ),
          );
  }
}

// class CustomSquare extends StatelessWidget {
//   Offset position;

//   CustomSquare({
//     super.key,
//     required this.position,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.red,
//       height: 50,
//       width: 50,
//       child: CustomPaint(
//         size: Size(50, 50),
//         painter: PrecedentPainter(),
//       ),
//     );
//   }
// }

class Square {
  final String name;
  Offset position;

  Square({
    required this.name,
    required this.position,
  });
}


//   const UseCasePage({Key? key, required this.diagram}) : super(key: key);

//   @override
//   _UseCasePageState createState() => _UseCasePageState();
// }

// class _UseCasePageState extends State<UseCasePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             colors: [
//               Color(0xff80a6ff),
//               Color.fromARGB(239, 128, 166, 255),
//               Color.fromARGB(222, 128, 166, 255),
//             ],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Container(
//                 //   height: 45,
//                 //   width: 300,
//                 //   decoration: BoxDecoration(
//                 //     border: Border.all(
//                 //       color: Colors.black,
//                 //       width: 1,
//                 //     ),
//                 //     color: const Color(0xfff8f8f8),
//                 //     borderRadius: BorderRadius.circular(3),
//                 //   ),
//                 //   child: Text(
//                 //     widget.diagram.getName,
//                 //     textAlign: TextAlign.center,
//                 //     style: const TextStyle(color: Colors.black, fontSize: 25),
//                 //   ),
//                 // ),
//                 // const Spacer(),
//                 // Transform.translate(
//                 //     offset: const Offset(-10, 10),
//                 //     child: ActionsButton(
//                 //       buttonText: 'СОХРАНИТЬ',
//                 //       containerWidth: 450,
//                 //       containerHeight: 50,
//                 //       onPressed: () {
//                 //         Navigator.push(
//                 //           context,
//                 //           MaterialPageRoute(
//                 //             builder: (context) => const LoginPage(),
//                 //           ),
//                 //         );
//                 //       },
//                 //       colorBox: const Color(0xff80ff8c),
//                 //     )),
//                 // const SizedBox(
//                 //   width: 150,
//                 // ),
//                 // Transform.translate(
//                 // offset: const Offset(-10, 10),
//                 //child: Container(
//                 // height: double.infinity,
//                 Expanded(
//                   child: Column(
//                     children: [
//                       ActionsButton(
//                         buttonText: 'ВЫЙТИ',
//                         containerWidth: 450,
//                         containerHeight: 50,
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LoginPage(),
//                             ),
//                           );
//                         },
//                         colorBox: const Color.fromARGB(255, 255, 128, 128),
//                       ),
//                       Expanded(
//                         child: Container(
//                           //padding: EdgeInsets.fromLTRB(100, 10, 1000, 1000),
//                                            //  height: double.infinity,
//                           width: 600,
//                           //height: double.infinity,
//                           color: Colors.amber,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 25,
//             ),

//             // Container(
//             //     padding:  EdgeInsets.fromLTRB(100, 10, 1000, 1000),

//             //   height: 100,
//             //   width: 100,
//             //   color: Colors.amber,
//             // ),
//           //  const Spacer(),
//             const UserInfo(),
//           ],
//         ),
//       ),
//     );
//   }
// }



class UserEditPage extends StatefulWidget {
  final User? user;
  final bool isCreating;
  final List<Group> groups;

  const UserEditPage(
      {super.key, this.user, required this.isCreating, required this.groups});

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Group? _selectedGroup;

  @override
  void initState() {
    super.initState();
    if (!widget.isCreating) {
      _nameController.text = widget.user!.name!;
      _usernameController.text = widget.user!.username!;
      _selectedGroup = widget.groups.firstWhere(
          (group) => group.id == widget.user!.group?.id,
          orElse: () => widget.groups[0]);
    } else {
      _selectedGroup = widget.groups.isNotEmpty ? widget.groups[0] : null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.isCreating
                ? 'Создать пользователя'
                : 'Редактировать пользователя',
            style: const TextStyle(color: Colors.black87),
          ),
        ),
        backgroundColor: const Color(0xff80a6ff),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            colors: [
              Color(0xff80a6ff),
              Color.fromARGB(239, 128, 166, 255),
              Color.fromARGB(222, 128, 166, 255),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(0xfff8f8f8),
              ),
              height: 360,
              width: 600,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff80a6ff),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: GoogleFonts.lobster(fontSize: 18),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.roboto(fontSize: 18),
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Icon(
                              Icons.person,
                              color: Color(0xfff8f8f8),
                            ),
                          ),
                          labelText: 'ИМЯ ПОЛЬЗОВАТЕЛЯ',
                          hintText: 'Иванов И. И.',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff80a6ff),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        style: GoogleFonts.lobster(fontSize: 18),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.roboto(fontSize: 18),
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Icon(
                              Icons.login,
                              color: Color(0xfff8f8f8),
                            ),
                          ),
                          labelText: 'ЛОГИН ПОЛЬЗОВАТЕЛЯ',
                          hintText: 'Ivanov_ii',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 0, bottom: 20),
                    child: PasswordField(
                      controller: _passwordController,
                      isReg: widget.isCreating,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 0, bottom: 20),
                    child: ValueDropdown<Group>(
                      items: widget.groups,
                      selectedItem: _selectedGroup!,
                      onChanged: (Group? newGroup) {
                        setState(() {
                          _selectedGroup = newGroup;
                        });
                      },
                      labelText:
                          'Выберите группу (студент) или кафедру (преподаватель)',
                      iconData: Icons.group,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ActionsButton(
              onPressed: () {
                if (_nameController.text.isEmpty ||
                    _usernameController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => const MessageDialog(
                        title: 'Ошибка регистрации',
                        message: "Пожалуйста, заполните все поля"),
                  );
                } else {
                  final user = User(
                      id: widget.isCreating ? null : widget.user!.id,
                      name: _nameController.text,
                      username: _usernameController.text,
                      password: _passwordController.text,
                      group: _selectedGroup);
                  (widget.isCreating
                          ? UserApi.createUser(user)
                          : UserApi.updateUser(user))
                      .then((_) {
                    showDialog(
                      context: context,
                      builder: (context) => MessageDialog(
                        title: 'УСПЕХ!',
                        message: widget.isCreating
                            ? 'Пользователь успешно добавлен'
                            : 'Пользователь успешно изменен',
                      ),
                    ).then((_) {
                      Navigator.of(context).pop();
                    });
                  }).catchError((error) {
                    showDialog(
                      context: context,
                      builder: (context) => MessageDialog(
                        title: widget.isCreating
                            ? 'Ошибка регистрации'
                            : 'Ошибка изменения',
                        message: error.toString(),
                      ),
                    );
                  });
                }
              },
              containerWidth: 350.0,
              containerHeight: 50.0,
              buttonText: widget.isCreating ? 'СОЗДАТЬ' : 'ИЗМЕНИТЬ',
              colorBox: widget.isCreating
                  ? const Color(0xff80ff8c)
                  : const Color(0xffffbd80),
            ),
          ],
        ),
      ),
    );
  }
}



class GroupAddPage extends StatefulWidget {
  const GroupAddPage({super.key});

  @override
  _GroupAddPageState createState() => _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kafedraController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _kafedraController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Создать группу',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        backgroundColor: const Color(0xff80a6ff),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            colors: [
              Color(0xff80a6ff),
              Color.fromARGB(239, 128, 166, 255),
              Color.fromARGB(222, 128, 166, 255),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(0xfff8f8f8),
              ),
              height: 255,
              width: 600,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff80a6ff),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: GoogleFonts.lobster(fontSize: 18),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.roboto(fontSize: 18),
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Icon(
                              Icons.group,
                              color: Color(0xfff8f8f8),
                            ),
                          ),
                          labelText: 'Введите новое имя группы',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff80a6ff),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _kafedraController,
                        style: GoogleFonts.lobster(fontSize: 18),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.roboto(fontSize: 18),
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Icon(
                              Icons.school,
                              color: Color(0xfff8f8f8),
                            ),
                          ),
                          labelText: 'Кафедра',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 0, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff80a6ff),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: GoogleFonts.lobster(fontSize: 18),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.roboto(fontSize: 18),
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Icon(
                              Icons.calendar_today,
                              color: Color(0xfff8f8f8),
                            ),
                          ),
                          labelText: 'Год',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ActionsButton(
              onPressed: () {
                if (_kafedraController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => const MessageDialog(
                        title: 'Ошибка добавления новой группы',
                        message: "Пожалуйста, заполните имя кафедры"),
                  );
                } else {
                  final group = Group(
                    name: _nameController.text.isNotEmpty
                        ? _nameController.text
                        : null,
                    kafedra: _kafedraController.text,
                    year: int.tryParse(_yearController.text),
                  );
                  print(group);
                  GroupApi.createGroup(group).then((_) {
                    showDialog(
                      context: context,
                      builder: (context) => MessageDialog(
                        title: 'УСПЕХ!',
                        message: group.name == null
                            ? 'Кафедра успешно добавлена'
                            : 'Группа успешно добавлена',
                      ),
                    ).then((_) {
                      Navigator.of(context).pop();
                    });
                  }).catchError((error) {
                    showDialog(
                      context: context,
                      builder: (context) => MessageDialog(
                        title: 'Ошибка добавления новой группы',
                        message: error.toString(),
                      ),
                    );
                  });
                }
              },
              containerWidth: 350.0,
              containerHeight: 50.0,
              buttonText: 'СОЗДАТЬ',
              colorBox: const Color(0xff80ff8c),
            ),
          ],
        ),
      ),
    );
  }
}



class VariantPage extends StatefulWidget {
  const VariantPage({Key? key}) : super(key: key);

  @override
  _VariantPageState createState() => _VariantPageState();
}

class _VariantPageState extends State<VariantPage> {
  String diagramName = "";
  List<Diagram> diagrams = [];

  Diagram? _selectedDiagram;

  @override
  void initState() {
    super.initState();
    _fetchDiagrams();
  }

  void _fetchDiagrams() async {
    List<Diagram> diagramsList = await DiagramApi.getDiagrams();
    setState(() {
      diagrams = diagramsList;
      _selectedDiagram = diagrams[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            colors: [
              Color(0xff80a6ff),
              Color.fromARGB(239, 128, 166, 255),
              Color.fromARGB(222, 128, 166, 255),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                    offset: const Offset(-10, 10),
                    child: ActionsButton(
                      buttonText: 'ВЫЙТИ',
                      containerWidth: 450,
                      containerHeight: 50,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      colorBox: const Color.fromARGB(255, 255, 128, 128),
                    )),
              ],
            ),
            SizedBox(
              height: 120,
              width: 300,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          _showDiagramCreationDialog(context);
                        },
                        child: const Text(
                          'Создать диаграмму',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          _showDiagramsUseCase(context);
                        },
                        child: const Text(
                          'Просмотреть диаграммы',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ]),
            ),
            const UserInfo(),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showDiagramCreationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Введите название диаграммы'),
          content: Container(
            decoration: BoxDecoration(
              color: const Color(0xff80a6ff),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              onChanged: (value) {
                diagramName = value;
              },
              style: GoogleFonts.lobster(fontSize: 18),
              decoration: InputDecoration(
                labelStyle: GoogleFonts.roboto(fontSize: 18),
                icon: const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xfff8f8f8),
                  ),
                ),
                labelText: 'Название диаграммы',
                hintText: 'Название',
                border: InputBorder.none,
              ),
            ),
          ),
          actions: [
            Center(
              child: Transform.translate(
                offset: const Offset(0, -15),
                child: TextButton(
                  onPressed: () {
                    User currentUser = UserRepository.instance.currentUser!;
                    DiagramType diagramType = DiagramType(id: 1);
                    Diagram newDiagram = Diagram(
                      user: currentUser,
                      diagramType: diagramType,
                      name: diagramName,
                      data: DateTime.now(),
                    );
                    DiagramApi.createDiagram(newDiagram).then((_) {
                      showDialog(
                        context: context,
                        builder: (context) => const MessageDialog(
                            title: 'УСПЕХ!',
                            message: 'Диаграмма успешно создана'),
                      ).then((_) {
                        _fetchDiagrams();
                        Navigator.of(context).pop();
                      });
                    }).catchError((error) {
                      showDialog(
                        context: context,
                        builder: (context) => MessageDialog(
                          title: 'Ошибка создания Диаграммы',
                          message: error.toString(),
                        ),
                      );
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'Создать',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showDiagramsUseCase(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: SizedBox(
                height: 122,
                width: 600,
                child: Column(
                  children: [
                    ValueDropdown<Diagram>(
                      items: diagrams,
                      selectedItem: _selectedDiagram!,
                      onChanged: (Diagram? newDiagram) {
                        setState(() {
                          _selectedDiagram = newDiagram;
                        });
                      },
                      labelText: 'Выберите диаграмму',
                      iconData: Icons.note_add_outlined,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Здесь вы можете добавить код, который будет выполняться при нажатии на кнопку "Перейти"
                        // Например, вы можете перейти к странице диаграммы
                        // print('Going to diagram: ${_selectedDiagram?.name}');
                      },
                      child: const Text('Перейти'),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}


import 'dart:convert';

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


