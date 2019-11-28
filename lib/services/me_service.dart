import 'dart:convert';

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

  logout(MainModel model) async {
    model.clearVotingTable();
    model.clearFriendList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  savePersonToSharedPref(String userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", userData);
  }

  void openWhatsApp(MainModel model) async {
    String url = Constant.whatsAppUrl + model.user.helpPhone;
    await canLaunch(url)
        ? launch(url)
        : commonWidgest.showToast("Failed to open WhatsApp");
  }

  void openTermsUrl() async {
    await canLaunch(Constant.termsUrl)
        ? launch(Constant.termsUrl)
        : commonWidgest.showToast("Failed to open Términos y Condiciones url");
  }
}
