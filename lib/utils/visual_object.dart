import 'package:flutter/material.dart';

abstract class IVisualObject {

  CustomPainter Function() customPainter;

  Offset position; 


  IVisualObject({required this.customPainter,required this.position});
}
