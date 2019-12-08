import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/person.dart';
import '../services/main_model.dart';

class SplashScreen extends StatefulWidget {
  final MainModel model;

  SplashScreen(this.model);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 120,
                width: 150,
              ),
            ),
          ),
        );
      },
    );
  }

  checkLoggedIn() async {
    Person user = widget.model.user;
    if (user == null) {
      await widget.model.loadUser();
      user = widget.model.user;

      if (user != null) {
        _loadDataFromSharedPref();
        _goToHome();
      } else {
        _goToLogin();
      }
    } else {
      Timer(
        Duration(seconds: 3),
        _goToHome(),
      );
    }
  }

  _goToLogin() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  _goToHome() {
    Timer(
      Duration(seconds: 5),
      () => Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
    );
  }

  _loadDataFromSharedPref() {
    widget.model.loadFriendsFromSharedPref(widget.model);
  }
}
