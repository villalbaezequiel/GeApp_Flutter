import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/model/save_request.dart';
import 'package:voting_app/ui/global/utils/constant.dart';

import 'main_model.dart';

mixin SavedRequestService on Model {
  static const String SAVE_REQUEST_KEY = "save_request";
  // this is used for all api call required for friends
  bool _isLoadingSavedService = false;

  List<SaveRequest> _savedRuestsList = [];

  bool get isLoadingSavedService => this._isLoadingSavedService;

  List<SaveRequest> get savedRuestsList => _savedRuestsList;

  addToSavedRequestsList(SaveRequest saveRequest) {
    var existingItem = _savedRuestsList.firstWhere(
        (itemToCheck) => (itemToCheck.id == saveRequest.id),
        orElse: () => null);
    if (existingItem == null) {
      this._savedRuestsList.add(saveRequest);
      this.saveRequestToSharedPref();
    }
  }

  /// Remove the entry and save to disk.
  removeFromSavedRequestsList(SaveRequest saveRequest) {
    var existingItem = _savedRuestsList.firstWhere(
        (itemToCheck) => (itemToCheck.id == saveRequest.id),
        orElse: () => null);
    if (existingItem != null) {
      this._savedRuestsList.remove(existingItem);
      this.saveRequestToSharedPref();
    }
  }

  clearSavedRequestsList() {
    this._savedRuestsList = null;
  }

  saveRequestToSharedPref() async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      List<String> requestList = _savedRuestsList
          .map((SaveRequest saveRequest) => json.encode(saveRequest.toJson()))
          .toList();
      prefs.setStringList(SAVE_REQUEST_KEY, requestList);
    });
  }

  loadSavedRequestsFromSharedPref(
      MainModel model, SharedPreferences prefs) async {
    var savedRequests = prefs.getStringList(SAVE_REQUEST_KEY);

    if (savedRequests != null) {
      this._savedRuestsList = [];
      for (String request in savedRequests) {
        this._savedRuestsList.add(SaveRequest.fromString(json.decode(request)));
      }
    }
  }

  callSavedRequests(MainModel model) async {
    this._isLoadingSavedService = true;
    notifyListeners();

    for (int i = 0; i < this._savedRuestsList.length; i++) {
      SaveRequest savedRequest = this._savedRuestsList[i];
      switch (savedRequest.requestType) {
        case 'delete':
          await deleteRequest(savedRequest, model);
          break;
        case 'post':
          await postRequest(savedRequest, model);
          break;
        case 'put':
          await putRequest(savedRequest, model);
          break;
      }
    }

    this._isLoadingSavedService = false;
    notifyListeners();
  }

  deleteRequest(SaveRequest saveRequest, MainModel model) async {
    try {
      var response =
          await http.delete(Constant.baseUrl + saveRequest.url, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user.token}",
      });

      if (response.statusCode == 200) {
        this.removeFromSavedRequestsList(saveRequest);
      }
    } catch (error) {
      print(error.message);
    }
  }

  postRequest(SaveRequest savedRequest, MainModel model) async {
    try {
      var response = await http.post(Constant.baseUrl + savedRequest.url,
          body: savedRequest.body,
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user.token}",
          });

      if (response.statusCode == 200) {
        this.removeFromSavedRequestsList(savedRequest);
      }
    } catch (error) {
      print(error.message);
    }
  }

  putRequest(SaveRequest savedRequest, MainModel model) async {
    try {
      var response = await http.put(Constant.baseUrl + savedRequest.url,
          body: savedRequest.body,
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user.token}",
          });

      if (response.statusCode == 200) {
        this.removeFromSavedRequestsList(savedRequest);
      }
    } catch (error) {
      print(error.message);
    }
  }
}
