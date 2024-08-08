import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Block extends ChangeNotifier {
  List<String> alignTypes = <String>['left', 'center', 'right'];

  String align = 'left';
  String alignHint = 'left';
  double x_ratio = 5;
  double y_ratio = 1;

  double getXSize() => x_ratio;
  double getYSize() => y_ratio;
  
  void setAlign(String newAlign) => align = newAlign;
  void setXRatio(double newX) => x_ratio = newX;
  void setYRatio(double newY) => y_ratio = newY;

  Widget? convert(double width) {}

  List<Widget> getProperties(){return [];}
}
