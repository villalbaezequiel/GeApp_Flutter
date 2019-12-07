import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/services/election_service.dart';
import 'package:voting_app/services/voting_service.dart';
import 'package:voting_app/ui/global/utils/constant.dart';

import 'friend_service.dart';
import 'me_service.dart';

class MainModel extends Model
    with MeService, FriendService, VotingService, ElectionService {
  DateTime _lastFetchedTime = DateTime.now();
  DateTime _votingTableFetchedTime = DateTime.now();

  String get lastFriendListFetchedTime =>
      Constant.dateFormatter.format(_lastFetchedTime);

  String get lastVotingTableFetchedTime =>
      Constant.dateFormatter.format(_votingTableFetchedTime);

  setFriendFetchedTime(DateTime dateTime) {
    _lastFetchedTime = dateTime;
    // notifyListeners();
  }

  setVotingTableFetchedTime(DateTime dateTime) {
    _votingTableFetchedTime = dateTime;
    // notifyListeners();
  }

  checkDiability(String path) {
    if (path == "/my_voting_table_list" || path == '/escrutinio') {
      if (user != null &&
          user.isOwner &&
          votingTable != null &&
          votingTable.isOpen) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
