import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uml/api/diagram_api.dart';
import 'package:uml/models/diagram.dart';
import 'package:uml/models/diagram_type.dart';
import 'package:uml/models/user.dart';
import 'package:uml/pages/login_page.dart';
import 'package:uml/repository/user_repository.dart';
import 'package:uml/widgets/actions_button.dart';
import 'package:uml/widgets/message_dialog.dart';
import 'package:uml/widgets/user_info.dart';
import 'package:uml/widgets/value_dropdown.dart';

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
