import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uml/api/group_api.dart';
import 'package:uml/widgets/message_dialog.dart';
import 'package:uml/models/group.dart';
import 'package:uml/widgets/actions_button.dart';

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
