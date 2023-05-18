import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uml/pages/variant_page.dart';
import 'package:uml/widgets/message_dialog.dart';
import 'package:uml/widgets/actions_button.dart';
import 'package:uml/widgets/password_field.dart';
import 'package:uml/repository/user_repository.dart';
import 'package:uml/pages/student_page.dart';

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
