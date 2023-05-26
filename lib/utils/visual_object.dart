import 'package:flutter/material.dart';

abstract class IVisualObject {
  CustomPainter Function() customPainter;
  String Function() elementText;

  Offset position;

  // double? size;

  IVisualObject(
      {required this.customPainter,
      required this.position,
      required this.elementText});

  set newName(String name) {}

  // String get newId;
  set newId(int newId);
}
