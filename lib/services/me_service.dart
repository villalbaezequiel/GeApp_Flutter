import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/model/person.dart';

mixin MeService on Model {
  Person _me;

  Person get user => _me;

  loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString('user');
    if (userString != null) {
      _me = Person.fromString(json.decode(userString));
    }
    notifyListeners();
  }

  setUser(Person user) {
    _me = user;
    notifyListeners();
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  savePersonToSharedPref(String userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", userData);
  }
}
