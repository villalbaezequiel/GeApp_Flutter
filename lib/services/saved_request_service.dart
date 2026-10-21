import 'package:collection/collection.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/model/save_request.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/constant.dart';


mixin SavedRequestService on Model {
  static const String SAVE_REQUEST_KEY = "save_request";
  // this is used for all api call required for friends
  bool _isLoadingSavedService = false;

  List<SaveRequest> _savedRuestsList = [];

  bool get isLoadingSavedService => this._isLoadingSavedService;

  List<SaveRequest> get savedRuestsList => _savedRuestsList;

  addToSavedRequestsList(SaveRequest saveRequest) {
    var existingItem = _savedRuestsList
        .firstWhereOrNull((itemToCheck) => (itemToCheck.id == saveRequest.id));
    if (existingItem == null) {
      this._savedRuestsList.add(saveRequest);
      this.saveRequestToSharedPref();
    }
  }

  /// Remove the entry and save to disk.
  removeFromSavedRequestsList(SaveRequest saveRequest) {
    var existingItem = _savedRuestsList
        .firstWhereOrNull((itemToCheck) => (itemToCheck.id == saveRequest.id));
    if (existingItem != null) {
      this._savedRuestsList.remove(existingItem);
      this.saveRequestToSharedPref();
    }
  }

  clearSavedRequestsList() {
    this._savedRuestsList = [];
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
        case 'send':
          await uploadFileRequest(savedRequest, model);
          break;
      }
    }

    this._isLoadingSavedService = false;
    notifyListeners();
  }

  deleteRequest(SaveRequest saveRequest, MainModel model) async {
    try {
      var response = await http
          .delete(Uri.parse(Constant.baseUrl() + saveRequest.url!), headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user!.token}",
      });

      if (response.statusCode == 401 || response.statusCode == 403) {
        model.clearAllData(model);
      }

      if (response.statusCode == 200) {
        this.removeFromSavedRequestsList(saveRequest);
      }
    } catch (error) {
      print(error);
    }
  }

  postRequest(SaveRequest savedRequest, MainModel model) async {
    try {
      var response = await http.post(
          Uri.parse(Constant.baseUrl() + savedRequest.url!),
          body: savedRequest.body,
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user!.token}",
          });
      if (response.statusCode == 401 || response.statusCode == 403) {
        model.clearAllData(model);
      }
      if (response.statusCode == 200) {
        this.removeFromSavedRequestsList(savedRequest);
      }
    } catch (error) {
      print(error);
    }
  }

  putRequest(SaveRequest savedRequest, MainModel model) async {
    try {
      var response = await http.put(
          Uri.parse(Constant.baseUrl() + savedRequest.url!),
          body: savedRequest.body,
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user!.token}",
          });
      if (response.statusCode == 401 || response.statusCode == 403) {
        model.clearAllData(model);
      }
      if (response.statusCode == 200) {
        this.removeFromSavedRequestsList(savedRequest);
      }
    } catch (error) {
      print(error);
    }
  }

  uploadFileRequest(SaveRequest savedRequest, MainModel model) async {
    try {
      File imageNewFile = File(savedRequest.body!);
      final mimeTypeData =
          lookupMimeType(imageNewFile.path, headerBytes: [0xFF, 0xD8])!
              .split('/');

      var postUri = Uri.parse(Constant.baseUrl() + Constant.scrutinyfile);
      var request = http.MultipartRequest("POST", postUri);
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'scrutinyImage', imageNewFile.path,
          contentType: MediaType(mimeTypeData[0],
              mimeTypeData[1])); //returns a Future<MultipartFile>

      request.files.add(multipartFile);
      request.headers.addAll({
        "Authorization": "Bearer ${model.user!.token}",
        'Content-Type': 'multipart/form-data;',
        "Accept": "application/json",
      });
      var response = await request.send();

      if (response.statusCode == 401 || response.statusCode == 403) {
        model.clearAllData(model);
      }
      if (response.statusCode == 200) {
        print('file uploaded with saved req');
        model.updateVotingTableIsOpen(false);
      }
    } catch (error) {
      print(error);
    }
  }
}
