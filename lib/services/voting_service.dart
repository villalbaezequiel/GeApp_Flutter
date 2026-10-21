import 'package:collection/collection.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/model/save_request.dart';
import 'package:voting_app/model/voter.dart';
import 'package:voting_app/model/voting_table.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/constant.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin VotingService on Model {
  static const String VOTING_TABLE_KEY = "voting_talble";

  bool _isLoadingVotingTable = false;
  bool _isVotingOrReplenish = false;

  VotingTable? _votingTable;

  CommonWidgest commonWidgests = CommonWidgest();

  bool get isLoadingVotingTable => _isLoadingVotingTable;

  bool get isVotingOrReplenish => _isVotingOrReplenish;

  VotingTable? get votingTable => _votingTable;

  Future<VotingTable?> fetchVotingTable(
      MainModel model, BuildContext context) async {
    try {
      _isLoadingVotingTable = true;
      notifyListeners();

      final response = await http
          .get(Uri.parse(Constant.baseUrl() + Constant.votingTable), headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user!.token}",
      });

      if (!model.isLoadingSavedService && model.savedRuestsList.length > 0)
        model.callSavedRequests(model);

      if (response.statusCode == 401 || response.statusCode == 403) {
        model.logout(model, context);
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        _votingTable = VotingTable.fromJson(mapResponse);
        model.setVotingTableFetchedTime(DateTime.now());
        saveVotingTableToSharedPref();
        _isLoadingVotingTable = false;
        notifyListeners();
        return _votingTable;
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);

        commonWidgests.showToast(errors.message!);
        _isLoadingVotingTable = false;
        notifyListeners();
        return null;
      }
    } catch (error) {
      _isLoadingVotingTable = false;
      catchExceptions(error, 'Sin conexión, por favor intente luego');
      return null;
    }
  }

  Voter? validateVoterOrder(int order) {
    return _votingTable!.voters!.firstWhereOrNull(
        (voter) => (voter.order == order && voter.voted == false));
  }

  Future vote(MainModel model, Voter voter, BuildContext context) async {
    var url = Constant.votingTable + Constant.vote + voter.id.toString();

    try {
      _isVotingOrReplenish = true;
      notifyListeners();

      await setVoterAsVoted(voter);

      final response =
          await http.put(Uri.parse(Constant.baseUrl() + url), headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user!.token}",
      });

      if (!model.isLoadingSavedService && model.savedRuestsList.length > 0)
        model.callSavedRequests(model);

      if (response.statusCode == 401 || response.statusCode == 403) {
        model.logout(model, context);
      }

      if (response.statusCode != 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);

        commonWidgests.showToast(errors.message!);
      }
      _isVotingOrReplenish = false;
      notifyListeners();
    } catch (error) {
      _isVotingOrReplenish = false;

      if (error is SocketException) {
        model.addToSavedRequestsList(
          SaveRequest(
            id: DateTime.now().millisecond,
            url: url,
            body: '',
            requestType: 'put',
          ),
        );
      }
      catchExceptions(error,
          'No se encontró conexión a internet. El voto se enviará cuando tenga conexión');
    }
  }

  Future replenishVote(
      MainModel model, int quantity, BuildContext context) async {
    var url = Constant.votingTable + Constant.replenish + quantity.toString();
    try {
      _isVotingOrReplenish = true;
      notifyListeners();

      final response =
          await http.put(Uri.parse(Constant.baseUrl() + url), headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user!.token}",
      });

      if (!model.isLoadingSavedService && model.savedRuestsList.length > 0)
        model.callSavedRequests(model);

      if (response.statusCode == 401 || response.statusCode == 403) {
        model.logout(model, context);
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        commonWidgests.showToast(mapResponse['message']);
        _isVotingOrReplenish = false;
        notifyListeners();
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);

        commonWidgests.showToast(errors.message!);
        _isVotingOrReplenish = false;
        notifyListeners();
      }
    } catch (error) {
      _isVotingOrReplenish = false;

      if (error is SocketException) {
        model.addToSavedRequestsList(
          SaveRequest(
            id: DateTime.now().millisecond,
            url: url,
            body: '',
            requestType: 'put',
          ),
        );
      }

      catchExceptions(error,
          'No se encontró conexión a internet. La sreposición se registrará cuando tenga conexión');
    }
  }

  clearVotingTable() {
    _votingTable = null;
  }

  saveVotingTableToSharedPref() async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String votingTable = json.encode(this._votingTable!.toJson());
      prefs.setString(VOTING_TABLE_KEY, votingTable);
    });
  }

  loadVotingTableFromSharedPref(
      MainModel model, SharedPreferences prefs) async {
    this._isLoadingVotingTable = true;
    notifyListeners();
    var votingTable = prefs.getString(VOTING_TABLE_KEY);

    if (votingTable != null) {
      this._votingTable = VotingTable.fromString(json.decode(votingTable));
      model.getVotingTableTimeFromSharedPref(prefs);
    }
    this._isLoadingVotingTable = false;
    notifyListeners();
  }

  updateVotingTableIsOpen(bool isOpen) {
    this._votingTable!.isOpen = isOpen;
    this.saveVotingTableToSharedPref();
  }

  catchExceptions(error, String s) {
    if (error is SocketException) {
      commonWidgests.showToast(s);
    } else {
      commonWidgests.showToast(error.message);
    }
    notifyListeners();
  }

  setVoterAsVoted(Voter voter) {
    _votingTable!.voters!.remove(voter);
    _isVotingOrReplenish = false;
    _isLoadingVotingTable = true;
    notifyListeners();

    voter.voted = true;
    _votingTable!.voters!.add(voter);
    _votingTable!.voters!.sort((a, b) {
      if (a.order == b.order) {
        return 0;
      } else if (a.order! > b.order!) {
        return 1;
      } else {
        return -1;
      }
    });
    this._votingTable!.sumVotes = this._votingTable!.sumVotes! + 1;

    _isLoadingVotingTable = false;
    notifyListeners();
  }
}
