import 'dart:ui';

import 'package:flutter/material.dart';

class Constant {
  static const Color primary = Color(0xFF717ed3);
  static const Color ascent = Color(0xFF40b3f7);
  static Color bgColor = Colors.grey.shade50;
  static LinearGradient gradient = LinearGradient(
    colors: [ascent, primary],
  );
  static LinearGradient appBarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.5, 1.0],
    colors: [Constant.primary, Constant.ascent],
  );
}
