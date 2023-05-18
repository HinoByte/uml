class Connection {
  bool leftCheckboxValue;
  bool rightCheckboxValue;

  Connection({this.leftCheckboxValue = false, this.rightCheckboxValue = false});

  bool get isArrowConnected => leftCheckboxValue && rightCheckboxValue;
}
