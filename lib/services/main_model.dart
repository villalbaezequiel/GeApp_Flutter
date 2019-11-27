import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/services/voting_service.dart';
import 'package:voting_app/ui/global/utils/constant.dart';

import 'friend_service.dart';
import 'me_service.dart';

class MainModel extends Model with MeService, FriendService, VotingService {
  DateTime _lastFetchedTime = DateTime.now();
  DateTime _votingTableFetchedTime = DateTime.now();

  String get lastFriendListFetchedTime =>
      Constant.dateFormatter.format(_lastFetchedTime);

  String get lastVotingTableFetchedTime =>
      Constant.dateFormatter.format(_votingTableFetchedTime);

  setFriendFetchedTime(DateTime dateTime) {
    this._lastFetchedTime = dateTime;
    // notifyListeners();
  }

  setVotingTableFetchedTime(DateTime dateTime) {
    this._votingTableFetchedTime = dateTime;
    // notifyListeners();
  }
}
