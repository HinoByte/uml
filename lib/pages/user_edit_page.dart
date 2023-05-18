import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uml/api/user_api.dart';
import 'package:uml/widgets/message_dialog.dart';
import 'package:uml/models/group.dart';
import 'package:uml/models/user.dart';
import 'package:uml/widgets/actions_button.dart';
import 'package:uml/widgets/password_field.dart';
import 'package:uml/widgets/value_dropdown.dart';

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
