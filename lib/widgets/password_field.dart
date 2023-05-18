import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
