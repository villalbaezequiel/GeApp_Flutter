import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/model/person.dart';

mixin MeService on Model {
  Person _me;

  Person getUser() {
    return _me;
  }

  loadUsesr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString('user');
    if (userString != null) {
      _me = Person.fromString(json.decode(userString));
    }
    notifyListeners();
  }
}
