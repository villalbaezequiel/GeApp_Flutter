import 'dart:convert';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/model/voter.dart';
import 'package:voting_app/model/voting_table.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/constant.dart';

import 'package:http/http.dart' as http;
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin VotingService on Model {
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
    return _votingTable.voters
        .firstWhere((voter) => (voter.order == order), orElse: () => null);
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
              Constant.vote +
              quantity.toString(),
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user.token}",
          });

      if (response.statusCode == 200) {
        commonWidgests.showToast("replenish Done");
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
}
