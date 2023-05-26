import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uml/api/diagram_type_api.dart';
import 'package:uml/api/relationship_api.dart';
import 'package:uml/api/uml_object_api.dart';
import 'package:uml/models/diagram.dart';
import 'package:uml/models/relationship.dart';
import 'package:uml/models/relationship_type.dart';
import 'package:uml/models/uml_object.dart';
import 'package:uml/models/uml_object_type.dart';
import 'package:uml/pages/login_page.dart';
import 'package:uml/utils/connections.dart';
import 'package:uml/utils/visual_object.dart';
import 'package:uml/widgets/connection_widget.dart';
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
  UmlObject? findObjects(Relationship rel) {
    for (var obj in visualObjects) {
      // If the object is a relationship, check its objectStart
      if (obj is Relationship &&
          (obj.objectStart?.id == rel.id || obj.objectEnd?.id == rel.id)) {
        print('start');
        if (obj.objectStart?.id == rel.id) {
          print('hi');
          rel.objectStart!.merge(obj.objectStart!);
        } else if (obj.objectEnd?.id == rel.id) {
          print('h1');
          rel.objectEnd!.merge(obj.objectEnd!);
        }
      }
    }
    return null;
  }

//  UmlObject findUmlObjectById(int id) {
//   return visualObjects.firstWhere((object) => object.id == id) as UmlObject;

  int idCounter = 0;

  List<IVisualObject> visualObjects = [];

  // void createNewVisualObject() {
  //   setState(() {
  //     IVisualObject visualObject = // Создайте ваш новый объект здесь
  //     visualObject.newId = idCounter;
  //     visualObjects.add(visualObject);
  //     idCounter--;
  //   });
  // }

// }
  //List<IVisualObject> visualObjects = [
  // UmlObject(objectType: ObjectType(name: 'Actor'), dimension: 100),
  // UmlObject(objectType: ObjectType(name: 'UseCase'), dimension: 100)
  //   ..position = const Offset(20, 0),
  // Relationship(
  //   relationshipType: RelationshipType(name: 'Association'),
  //   objectStart:
  //       UmlObject(objectType: ObjectType(name: 'Actor'), dimension: 100),
  //   objectEnd:
  //       UmlObject(objectType: ObjectType(name: 'UseCase'), dimension: 100)
  //         ..position = const Offset(20, 0),
  // )..position = const Offset(150, 150),
  // //..isArrowConnected,
  // Relationship(
  //   relationshipType: RelationshipType(name: 'Association'),
  // )..position = const Offset(150, 150),

  //   ];

  final List<String> relationshipTypes = [
    'Association',
    'Dependency',
    'Generalization',
    'Include',
    'Extend',
  ];
  final List<String> objectTypes = [
    'Actor',
    'UseCase',
    'Boundary',
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<Relationship> relationships = [];
    List<UmlObject> objects = [];
    try {
      relationships = await RelationshipApi.getRelationshipsByDiagramId(1);
      print(relationships);
      objects = await UmlObjectApi.getUmlObjects();
      visualObjects = visualObjects + relationships;
      visualObjects = visualObjects + objects;
      // print(visualObjects.length);
    } catch (e) {
      print('Failed to load data: $e');
    }
    setState(() {}); // Call setState to update the UI when data is loaded.
  }

  // @override
  // void initState() async {
  //   super.initState();
  //   //var objects = UmlObjectApi.getUmlObjects();
  //   // var relationships = RelationshipApi.getRelationships().then((value) => print(value));
  //   //print(relationships);
  //   //rint(objects);
  //       List<Relationship> relationships = [];
  //   List<UmlObject> objects = await UmlObjectApi.getUmlObjects();
  //  visualObjects =  visualObjects + relationships + objects;
  // print(visualObjects.length);
  // //..relationships..objects;
  //   try {
  //     relationships = await RelationshipApi.getRelationshipsByDiagramId(1);
  //     objects = await UmlObjectApi.getUmlObjects();
  //     print(objects);
  //   } catch (e) {
  //     print('Failed to load relationships: $e');
  //   }

  // }

  // @override
  // void setState(VoidCallback fn) async {
  //   // TODO: implement setState
  //   super.setState(fn);
  //   //  var objects = UmlObjectApi.getUmlObjects();
  //   // var relationships = RelationshipApi.getRelationshipsByDiagramId(2).then((value) => print(value));

  // }

  final stackKey = GlobalKey();
  Relationship? activeConnection;

  Color associationPainterColor = Colors.red;

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
          _buildHeader(context),
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
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      for (IVisualObject visualObject in visualObjects) {
                        if (visualObject is Relationship &&
                            (visualObject).isArrowConnected) {
                          // var connection = visualObject;
                          var start = visualObject.start;
                          var end = visualObject.end;
                          double distance = calculateDistance(
                              (details.localPosition - visualObject.position),
                              start,
                              end);
                          if (distance < 8) {
                            setState(() {
                              visualObject.hasConnectedDiagrams =
                                  !visualObject.hasConnectedDiagrams;
                            });
                            print('yes yes yes $visualObject');
                            findObjects(visualObject);
                            print(
                                " object ${visualObject.objectStart?.position}}");
                          }
                        }
                      }
                    },
                    child: SizedBox(
                      // color: Colors.amber,
                      height: screenHeight * 0.77,
                      child: Stack(
                        key: stackKey,
                        children: visualObjects.map((object) {
                          return Positioned(
                            left: object.position.dx,
                            top: object.position.dy,
                            child: Draggable<IVisualObject>(
                              data: object,
                              feedback: (object is Connection)
                                  ? ConnectionWidget(
                                      object: object,
                                      visualObjects: visualObjects)
                                  : _drawEntity(object as UmlObject),
                              childWhenDragging: Container(),
                              onDragUpdate: (DragUpdateDetails dragDetails) {
                                setState(() {
                                  final RenderBox stackBox = stackKey
                                      .currentContext!
                                      .findRenderObject() as RenderBox;
                                  final localPosition = stackBox
                                      .globalToLocal(dragDetails.localPosition);
                                  object.position = localPosition;
                                });
                              },
                              child: (object is Relationship)
                                  ? ConnectionWidget(
                                      object: object,
                                      visualObjects: visualObjects,
                                      inTable: true,
                                    )
                                  : _drawEntity(object as UmlObject),
                            ),
                          );
                        }).toList(),
                      ),
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
                            color: Color(0xFF80A6FF),
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
                  _buildButtons()
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

  GestureDetector _drawEntity(UmlObject umlObject) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        if (activeConnection != null) {
          showDialog(
            context: context,
            builder: (_) => const MessageDialog(
              title: "Подтверждение",
              message: "Вы действительно хотите установить связь?",
            ),
          ).then((_) {
            setState(() {
              print(umlObject);
              for (var object in visualObjects) {
                if (object is Relationship && object == activeConnection) {
                  if (object.leftCheckboxValue && object.objectStart == null) {
                    object.objectStart = umlObject;
                    // print(' ОБЖЕКТ ${activeConnection}');
                  }
                  if (object.rightCheckboxValue && object.objectEnd == null) {
                    object.objectEnd = umlObject;
                  }
                }
              }

              activeConnection = null;
            });
          });
        }
      },
      child: Container(
        child: CustomPaint(
          size: (umlObject).size,
          painter: umlObject.customPainter(),
        ),
      ),
    );
  }

  Expanded _buildButtons() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: visualObjects.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Enter name',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    visualObjects[index].newName = value;
                                    print(value);
                                  });
                                },
                              ),
                              visualObjects[index] is Relationship
                                  ? ConnectionWidget(
                                      object: visualObjects[index],
                                      visualObjects: visualObjects,
                                      activeConnection: activeConnection,
                                      onCheckboxChanged: (object) {
                                        // print(activeConnection);
                                        setState(() {
                                          if (object == null) {
                                            activeConnection = null;
                                          } else if (object is Relationship) {
                                            activeConnection = object;
                                          }
                                        });
                                        // print(activeConnection);
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        visualObjects[index] is Relationship
                            ? Column(
                                children: [
                                  IconButton(
                                    iconSize: 22,
                                    icon: const Icon(Icons.arrow_upward),
                                    onPressed: () {
                                      setState(() {
                                        (visualObjects[index] as Relationship)
                                            .y = (visualObjects[index]
                                                    as Relationship)
                                                .y! -
                                            5;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 22,
                                    icon: const Icon(Icons.arrow_downward),
                                    onPressed: () {
                                      setState(() {
                                        (visualObjects[index] as Relationship)
                                            .y = (visualObjects[index]
                                                    as Relationship)
                                                .y! +
                                            5;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  IconButton(
                                    iconSize: 22,
                                    icon: const Icon(Icons.zoom_in),
                                    onPressed: () {
                                      setState(() {
                                        (visualObjects[index] as UmlObject)
                                                .size =
                                            Size(
                                                (visualObjects[index]
                                                            as UmlObject)
                                                        .size
                                                        .height +
                                                    10,
                                                (visualObjects[index]
                                                            as UmlObject)
                                                        .size
                                                        .height +
                                                    10);
                                      });
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 22,
                                    icon: const Icon(Icons.zoom_out),
                                    onPressed: () {
                                      setState(() {
                                        (visualObjects[index] as UmlObject)
                                                .size =
                                            Size(
                                                (visualObjects[index]
                                                            as UmlObject)
                                                        .size
                                                        .height -
                                                    10,
                                                (visualObjects[index]
                                                            as UmlObject)
                                                        .size
                                                        .height -
                                                    10);
                                      });
                                    },
                                  ),
                                ],
                              ),
                        IconButton(
                          iconSize: 22,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              visualObjects.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                ...[...relationshipTypes, ...objectTypes].map((type) {
                  return Column(
                    children: [
                      _buildButtoms(
                        visualObject: relationshipTypes.contains(type)
                            ? Relationship(
                                relationshipType: RelationshipType(name: type),
                              )
                            : UmlObject(objectType: ObjectType(name: type)),
                        title: type,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                    for (IVisualObject visualObject in visualObjects) {
                      if (visualObject is UmlObject) {
                        UmlObject object = UmlObject(
                          diagram: widget.diagram,
                          name: 'Актер',
                          x: visualObject.position.dx,
                          y: visualObject.position.dy,
                        );
                        UmlObjectApi.createUmlObject(object);
                      } else if (visualObject is Relationship) {
                        // RelationshipApi.createRelationship(visualObject);
                      }
                    }

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const LoginPage(),
                    //   ),
                    // );
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
    ]);
  }

  Container _buildButtoms(
      {required IVisualObject visualObject, required String title}) {
    // print(visualObject.runtimeType);
    return Container(
      //  color: Colors.black,
      width: 135,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // print(visualObject);
          setState(() {
            idCounter--;
            visualObject.newId = idCounter;
            visualObjects.add(visualObject);
            // print(visualObjects);
            // _actors.add(CustomPaint(size: Size(50, 50), painter: ActorPainter()));
          });
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xFFBEBEBE)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),

        child: Text(title), //TODO ИМЯ правильно
      ),
    );
  }

  double calculateDistance(Offset localPosition, Offset? start, Offset? end) {
    if (start == null || end == null) {
      throw ArgumentError('Start and end points must not be null');
    }

    double numerator = ((end.dy - start.dy) * localPosition.dx) -
        ((end.dx - start.dx) * localPosition.dy) +
        (end.dx * start.dy) -
        (end.dy * start.dx);
    double denominator =
        sqrt(pow(end.dy - start.dy, 2) + pow(end.dx - start.dx, 2));

    return (numerator / denominator).abs();
  }
}
