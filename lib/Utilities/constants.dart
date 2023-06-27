import 'package:flutter/material.dart';

Color grey1 = Colors.grey;
Color grey2 = Colors.grey.shade700;
Color purple1 = Colors.deepPurpleAccent;
Color purple2 = Colors.deepPurpleAccent.shade700;

class Config {
  BuildContext context;
  Config(this.context);
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}
