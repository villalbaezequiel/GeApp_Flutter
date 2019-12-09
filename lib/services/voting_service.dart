import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/model/voter.dart';
import 'package:voting_app/model/voting_table.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/constant.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin VotingService on Model {
  static const String VOTING_TABLE_KEY = "voting_talble";

  bool _isloadingVotingTable = false;
  bool _isVotingOrReplenish = false;

  VotingTable _votingTable;

  CommonWidgest commonWidgests = CommonWidgest();

  bool get isloadingVotingTable => _isloadingVotingTable;

  bool get isVotingOrReplenish => _isVotingOrReplenish;

  VotingTable get votingTable => _votingTable;

  Future<VotingTable> fetchVotingTable(MainModel model) async {
    try {
      _isloadingVotingTable = true;
      notifyListeners();

      final response =
          await http.get(Constant.baseUrl + Constant.votingTable, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user.token}",
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        _votingTable = VotingTable.fromJson(mapResponse);
        model.setVotingTableFetchedTime(DateTime.now());
        saveVotingTableToSharedPref();
        _isloadingVotingTable = false;
        notifyListeners();
        return _votingTable;
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);

        commonWidgests.showToast(errors.message);
        _isloadingVotingTable = false;
        notifyListeners();
        return null;
      }
    } catch (error) {
      _isloadingVotingTable = false;
      catchExceptions(error);
      return null;
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

  Voter validateVoterOrder(int order) {
    return _votingTable.voters.firstWhere(
        (voter) => (voter.order == order && voter.voted == false),
        orElse: () => null);
  }

  Future vote(MainModel model, Voter voter) async {
    try {
      _isVotingOrReplenish = true;
      notifyListeners();

      final response = await http.put(
          Constant.baseUrl +
              Constant.votingTable +
              Constant.vote +
              voter.id.toString(),
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user.token}",
          });

      if (response.statusCode == 200) {
        _votingTable.voters.remove(voter);
        _isVotingOrReplenish = false;
        _isloadingVotingTable = true;
        notifyListeners();

        voter.voted = true;
        _votingTable.voters.add(voter);
        _votingTable.voters.sort((a, b) {
          if (a.order == b.order) {
            return 0;
          } else if (a.order > b.order) {
            return 1;
          } else {
            return -1;
          }
        });
        this._votingTable.sumVotes++;
        _isloadingVotingTable = false;
        notifyListeners();
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);

        commonWidgests.showToast(errors.message);
        _isVotingOrReplenish = false;
        notifyListeners();
      }
    } catch (error) {
      _isVotingOrReplenish = false;

      catchExceptions(error);
    }
  }

  Future replenishVote(MainModel model, int quantity) async {
    try {
      _isVotingOrReplenish = true;
      notifyListeners();

      final response = await http.put(
          Constant.baseUrl +
              Constant.votingTable +
              Constant.replenish +
              quantity.toString(),
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user.token}",
          });

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        commonWidgests.showToast(mapResponse['message']);
        _isVotingOrReplenish = false;
        notifyListeners();
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);

        commonWidgests.showToast(errors.message);
        _isVotingOrReplenish = false;
        notifyListeners();
      }
    } catch (error) {
      _isVotingOrReplenish = false;

      catchExceptions(error);
    }
  }

  clearVotingTable() {
    _votingTable = null;
  }

  saveVotingTableToSharedPref() async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String votingTable = json.encode(this._votingTable.toJson());
      prefs.setString(VOTING_TABLE_KEY, votingTable);
    });
  }

  loadVotingTableFromSharedPref(
      MainModel model, SharedPreferences prefs) async {
    this._isloadingVotingTable = true;
    notifyListeners();
    var votingTable = prefs.getString(VOTING_TABLE_KEY);

    if (votingTable != null) {
      this._votingTable = VotingTable.fromString(json.decode(votingTable));
      model.getVotingTableTimeFromSharedPref(prefs);
    }
    this._isloadingVotingTable = false;
    notifyListeners();
  }

  updateVotingTableIsOpen(bool isOpen) {
    this._votingTable.isOpen = isOpen;
    this.saveVotingTableToSharedPref();
  }
}
