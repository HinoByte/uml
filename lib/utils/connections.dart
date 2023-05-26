import 'package:flutter/material.dart';

class Connection {
  bool leftCheckboxValue;
  bool rightCheckboxValue;
  bool hasConnectedDiagrams;
  Offset? start;
  Offset? end;

  Connection({
    this.leftCheckboxValue = false,
    this.rightCheckboxValue = false,
    this.hasConnectedDiagrams = false,
    this.start,
    this.end,
  });

  bool get isArrowConnected => leftCheckboxValue && rightCheckboxValue;
}
