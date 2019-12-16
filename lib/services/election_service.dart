import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/model/election.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/model/scrutiny_category.dart';
import 'package:voting_app/model/scrutiny_party.dart';
import 'package:voting_app/model/vote_election.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/constant.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin ElectionService on Model {
  static const String ELECTION_KEY = "election";

  CommonWidgest commonWidgests = CommonWidgest();

  bool _isloadingElection = false;

  Election _election;

  int _numberOfElectionVote = 0;

  VoteElection voteElection = VoteElection(quantities: [], notes: "");

  int get numberOfElectionVote => _numberOfElectionVote;

  bool get isloadingElection => _isloadingElection;

  Election get election => _election;

  Future<Election> fetchElection(MainModel model, BuildContext context) async {
    try {
      final response =
          await http.get(Constant.baseUrl + Constant.election, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user.token}",
      });

      if (response.statusCode == 401 || response.statusCode == 403) {
        model.logout(model, context);
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        this._election = Election.fromJson(mapResponse);
        saveElectionToSharedPref();
        this._isloadingElection = false;
        setNumberOfElectionVote();
        notifyListeners();
        return this._election;
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);

        commonWidgests.showToast(errors.message);
        _isloadingElection = false;
        notifyListeners();
        return null;
      }
    } catch (error) {
      _isloadingElection = false;
      catchExceptions(error);
      return null;
    }
  }

  setNumberOfElectionVote() {
    _election.scrutinycategories.forEach((category) {
      _numberOfElectionVote =
          _numberOfElectionVote + category.scrutinyparties.length;
    });
  }

  Future<bool> submitScrutiny(MainModel model, BuildContext context) async {
    try {
      _isloadingElection = true;
      notifyListeners();

      var body = json.encode(voteElection);
      var response = await http.post(Constant.baseUrl + Constant.scrutinyVotes,
          body: body,
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user.token}",
          });

      if (response.statusCode == 401 || response.statusCode == 403) {
        model.logout(model, context);
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        model.updateVotingTableIsOpen(false);
        _isloadingElection = false;
        notifyListeners();
        commonWidgests.showToast(mapResponse['message']);
        return true;
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);
        commonWidgests.showToast(errors.message);
        _isloadingElection = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _isloadingElection = false;
      catchExceptions(error);
      return false;
    }
  }

  Future<bool> uploadScrutinyImage(
      MainModel model, File scrutinyImage, BuildContext context) async {
    try {
      _isloadingElection = true;
      notifyListeners();

      final mimeTypeData =
          lookupMimeType(scrutinyImage.path, headerBytes: [0xFF, 0xD8])
              .split('/');

      var postUri = Uri.parse(Constant.baseUrl + Constant.scrutinyfile);
      var request = http.MultipartRequest("POST", postUri);
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'scrutinyImage', scrutinyImage.path,
          contentType: MediaType(mimeTypeData[0],
              mimeTypeData[1])); //returns a Future<MultipartFile>

      request.files.add(multipartFile);
      request.headers.addAll({
        "Authorization": "Bearer ${model.user.token}",
        'Content-Type': 'multipart/form-data;',
        "Accept": "application/json",
      });
      var response = await request.send();

      if (response.statusCode == 401 || response.statusCode == 403) {
        model.logout(model, context);
      }

      if (response.statusCode == 200) {
        commonWidgests.showToast("Imagen subida con éxito");
        return true;
      } else {
        commonWidgests.showToast("Fallo al subir imagen");
        _isloadingElection = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _isloadingElection = false;
      catchExceptions(error);
      return false;
    }
  }

  catchExceptions(error) {
    if (error is SocketException) {
      commonWidgests.showToast('Sin conexión, por favor intente luego');
    } else {
      commonWidgests.showToast(error.message);
    }
    notifyListeners();
  }

  saveElectionToSharedPref() async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String election = json.encode(this._election.toJson());
      prefs.setString(ELECTION_KEY, election);
    });
  }

  loadElectionFromSharedPref(MainModel model, SharedPreferences prefs) async {
    this._isloadingElection = true;
    notifyListeners();
    var election = prefs.getString(ELECTION_KEY);

    if (election != null) {
      this._election = Election.fromString(json.decode(election));
      this._numberOfElectionVote = 0;
      setNumberOfElectionVote();
    }

    this._isloadingElection = false;
    notifyListeners();
  }

  clearElection() {
    this._election = null;
  }

  addVote(Vote vote) {
    var existingItem = voteElection.quantities.firstWhere(
        (itemToCheck) => (itemToCheck.scrutinyPartyId == vote.scrutinyPartyId),
        orElse: () => null);
    if (existingItem == null) {
      voteElection.quantities.add(vote);
    } else {
      existingItem.qty = vote.qty;
      voteElection.quantities.remove(existingItem);
      voteElection.quantities.add(vote);
    }
  }

  void validateVoteForElection(
      String val, ScrutinyParty party, ScrutinyCategory scrutinyCategory) {
    if (val != null && val.isNotEmpty) {
      addVote(Vote(scrutinyPartyId: party.id, qty: int.parse(val)));
    } else {
      commonWidgests.showToast(
          "Por favor ingrese un número válido para ${party.name} en ${scrutinyCategory.name}");
    }
  }
}
