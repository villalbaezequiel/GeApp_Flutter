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

  // headers
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    "Accept": "application/json",
  };

  // API Endpoints base url
  static const String baseUrl = 'http://18.231.45.56:3000/api/';

  // user endpoints
  static const String login = 'user/login';
  static const String createUser = 'user/';

  // friends endpoints
  static const String friends = "friend/";

  // voting table
  static const String votingTable = "voting-table/";
  static const String vote = "vote/";
  static const String replenish = "replenish/";
}
