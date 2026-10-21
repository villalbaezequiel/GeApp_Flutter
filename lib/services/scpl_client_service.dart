import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/model/scpl_client.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/constant.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin ScplClientService on Model {
  static const String SCPL_CLIENT_KEY = "client";

  ScplClient? _client;

  bool _isLoadingScplClients = false;
  bool get isLoadingScplClients => _isLoadingScplClients;

  CommonWidgest commonWidgests = CommonWidgest();

  ScplClient? get client => _client;

  Future<ScplClient?> fetchClient(
      MainModel model, String dni, BuildContext context) async {
    var params = {"dni": dni};

    var body = json.encode(params);

    try {
      _isLoadingScplClients = true;
      notifyListeners();

      var response = await http.post(
          Uri.parse(Constant.baseUrl() + Constant.scplFetchClient),
          body: body,
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user!.token}",
          });

      if (!model.isLoadingSavedService && model.savedRuestsList.length > 0) {
        model.callSavedRequests(model);
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        return null;
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        this._client = ScplClient.fromJson(mapResponse);
        saveClientToSharedPref();
        _isLoadingScplClients = false;
        notifyListeners();

        return this._client;
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);
        commonWidgests.showToast(errors.message!);
        _isLoadingScplClients = false;
        notifyListeners();

        return null;
      }
    } catch (error) {
      _isLoadingScplClients = false;
      catchExceptions(error, 'Sin conexión, por favor intente luego');
      return null;
    }
  }

  Future<bool> avalClient(
      MainModel model, String id, BuildContext context) async {
    try {
      _isLoadingScplClients = true;
      notifyListeners();

      var params = {"referrerId": model.user!.id};

      var body = json.encode(params);

      var response = await http.put(
          Uri.parse(Constant.baseUrl() + Constant.scplAvalClient + '/' + id),
          body: body,
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user!.token}",
          });

      if (!model.isLoadingSavedService && model.savedRuestsList.length > 0) {
        model.callSavedRequests(model);
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        return false;
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        this._client = ScplClient.fromJson(mapResponse);
        saveClientToSharedPref();
        _isLoadingScplClients = false;
        notifyListeners();

        return true;
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);
        commonWidgests.showToast(errors.message!);
        _isLoadingScplClients = false;
        notifyListeners();

        return false;
      }
    } catch (error) {
      _isLoadingScplClients = false;
      catchExceptions(error, 'Sin conexión, por favor intente luego');
      return false;
    }
  }

  saveClientToSharedPref() async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String client = json.encode(this._client!.toJson());
      prefs.setString(SCPL_CLIENT_KEY, client);
    });
  }

  catchExceptions(error, String message) {
    if (error is SocketException) {
      commonWidgests.showToast(message);
    } else {
      commonWidgests.showToast(error.message);
    }
    notifyListeners();
  }
}
