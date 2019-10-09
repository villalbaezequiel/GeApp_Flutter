import 'package:flutter/material.dart';
import 'ui/home.dart';

void main() => runApp(MyApp());

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chubut al Frente',
      home: Home(),
      theme: ThemeData(
        primaryColor: Color(0xFF5974AB),
        //primaryColor: Color(0xFF1F2A5B),
        accentColor: Color(0xFF3DB3E3),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chubut al Frente',
      home: Home(),
      theme: ThemeData(
        primaryColor: Color(0xFF5974AB),
        //primaryColor: Color(0xFF1F2A5B),
        accentColor: Color(0xFF3DB3E3),
      ),
    );
  }
}
