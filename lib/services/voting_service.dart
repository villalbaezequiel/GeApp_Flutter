import 'dart:convert';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/model/voting_table.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/constant.dart';

import 'package:http/http.dart' as http;
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin VotingService on Model {
  bool _isloadingVotingTable = false;

  VotingTable _votingTable;

  CommonWidgest commonWidgests = CommonWidgest();

  bool get isloadingVotingTable => _isloadingVotingTable;

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

        commonWidgests.showToast("Success");
        _isloadingVotingTable = false;
        notifyListeners();

        return _votingTable;
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);
        _isloadingVotingTable = false;
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
}
