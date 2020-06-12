import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voting_app/model/person.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/constant.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin MeService on Model {
  Person _me;
  CommonWidgest commonWidgest = CommonWidgest();

  Person get user => _me;

  loadUserAndOtherData(MainModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString('user');
    if (userString != null) {
      _me = Person.fromString(json.decode(userString));
      loadOtherData(prefs, model);
    }
    notifyListeners();
  }

  loadUser(MainModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString('user');
    if (userString != null) {
      _me = Person.fromString(json.decode(userString));
    }
    notifyListeners();
  }

  loadOtherData(SharedPreferences prefs, MainModel model) async {
    model.loadFriendsFromSharedPref(model, prefs);
    model.loadVotingTableFromSharedPref(model, prefs);
    model.loadElectionFromSharedPref(model, prefs);
    model.loadSavedRequestsFromSharedPref(model, prefs);
  }

  setUser(Person user) {
    _me = user;
    notifyListeners();
  }

  logout(MainModel model, BuildContext context) async {
    await clearAllData(model);

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  clearAllData(MainModel model) async {
    model.clearVotingTable();
    model.clearFriendList();
    model.clearElection();
    // model.clearSavedRequestsList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  savePersonToSharedPref(String userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", userData);
  }

  void openWhatsApp() async {
    if (_me != null && _me.helpPhone != null && _me.helpPhone.isNotEmpty) {
      String url = Constant.whatsAppUrl + _me.helpPhone;
      await canLaunch(url)
          ? launch(url)
          : commonWidgest.showToast("Fallo al abrir WhatsApp");
    } else {
      commonWidgest.showToast("No hay un número de whatsapp disponible");
    }
  }

  void openTermsUrl() async {
    await canLaunch(Constant.termsUrl)
        ? launch(Constant.termsUrl)
        : commonWidgest.showToast("Failed to open Términos y Condiciones url");
  }
}
