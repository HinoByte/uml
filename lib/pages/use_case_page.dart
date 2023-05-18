import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uml/models/diagram.dart';
import 'package:uml/models/relationship.dart';
import 'package:uml/models/relationship_type.dart';
import 'package:uml/models/uml_object.dart';
import 'package:uml/models/uml_object_type.dart';
import 'package:uml/pages/login_page.dart';
import 'package:uml/utils/connections.dart';
import 'package:uml/utils/visual_object.dart';
import 'package:uml/widgets/message_dialog.dart';
import 'package:uml/widgets/actions_button.dart';
import 'package:uml/widgets/painters/relationships_painters/association_painter.dart';
import 'package:uml/widgets/user_info.dart';

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
