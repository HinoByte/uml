import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uml/models/diagram.dart';
import 'package:uml/pages/login_page.dart';
import 'package:uml/pages/student_page.dart';
import 'package:uml/pages/use_case_page.dart';
import 'package:uml/pages/variant_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          ),
      home: Scaffold(
        body: LoginPage(),
      ),
      // ),
    );
  }
}
