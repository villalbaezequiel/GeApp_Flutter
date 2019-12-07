import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/election.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/constant.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin ElectionService on Model {
  bool _isloadingElection = false;

  Election _election;

  CommonWidgest commonWidgests = CommonWidgest();

  bool get isloadingElection => _isloadingElection;

  Election get election => _election;

  Future<Election> fetchElection(MainModel model) async {
    try {
      final response =
          await http.get(Constant.baseUrl + Constant.election, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user.token}",
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        _election = Election.fromJson(mapResponse);
        // model.setVotingTableFetchedTime(DateTime.now());
        _isloadingElection = false;
        notifyListeners();
        return _election;
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

  Future submitScrutiny(MainModel model, String notes) {
    try {
      // hello
      return null;
    } catch (error) {
      _isloadingElection = false;
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
}
