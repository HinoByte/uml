import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uml/models/diagram.dart';
import 'package:uml/pages/login_page.dart';
import 'package:uml/pages/student_page.dart';
import 'package:uml/pages/use_case_page.dart';
import 'package:uml/pages/variant_page.dart';

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
