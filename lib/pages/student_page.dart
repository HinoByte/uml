import 'package:flutter/material.dart';
import 'package:uml/api/group_api.dart';
import 'package:uml/api/user_api.dart';
import 'package:uml/pages/group_add_page.dart';
import 'package:uml/pages/login_page.dart';
import 'package:uml/models/group.dart';
import 'package:uml/models/user.dart';
import 'package:uml/pages/user_edit_page.dart';
import 'package:uml/repository/user_repository.dart';
import 'package:uml/widgets/actions_button.dart';
import 'package:uml/widgets/message_dialog.dart';
import 'package:uml/widgets/user_info.dart';

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
