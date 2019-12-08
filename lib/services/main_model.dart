import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/services/election_service.dart';
import 'package:voting_app/services/voting_service.dart';
import 'package:voting_app/ui/global/utils/constant.dart';

import 'friend_service.dart';
import 'me_service.dart';

class MainModel extends Model
    with MeService, FriendService, VotingService, ElectionService {
  static const String VOTING_TABLE_TIME_KEY = "voting_table_time";
  static const String FRIEND_LIST_TIME_KEY = "friend_list_time";

  DateTime _lastFetchedTime = DateTime.now();
  DateTime _votingTableFetchedTime = DateTime.now();
  bool _disableEscrutinioButton = false;

  bool get isEscrutinioButtonDisabled => _disableEscrutinioButton;

  String get lastFriendListFetchedTime =>
      Constant.dateFormatter.format(_lastFetchedTime);

  String get lastVotingTableFetchedTime =>
      Constant.dateFormatter.format(_votingTableFetchedTime);

  setFriendFetchedTime(DateTime dateTime) {
    _lastFetchedTime = dateTime;
    saveFriendListTimeToSharedPred(dateTime);
  }

  setVotingTableFetchedTime(DateTime dateTime) {
    _votingTableFetchedTime = dateTime;
    saveVoteTableTimeToSharedPred(dateTime);
  }

  checkEnablity(String path) {
    if (path == "/my_voting_table_list" || path == '/escrutinio') {
      if (user != null &&
          user.isOwner &&
          votingTable != null &&
          votingTable.isOpen) {
        if (path == '/escrutinio' && isEscrutinioButtonDisabled) {
          return false;
        }
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  disableEscutinioButton(bool disable) {
    _disableEscrutinioButton = disable;
  }

  saveVoteTableTimeToSharedPred(DateTime dateTime) async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String votingTableTime = dateTime.toString();
      prefs.setString(VOTING_TABLE_TIME_KEY, votingTableTime);
    });
  }

  getVotingTableTimeFromSharedPref(SharedPreferences prefs) async {
    String votingTableTime = prefs.getString(VOTING_TABLE_TIME_KEY);
    this._votingTableFetchedTime = DateTime.parse(votingTableTime);
  }

  saveFriendListTimeToSharedPred(DateTime dateTime) async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String friendListTime = dateTime.toString();
      prefs.setString(FRIEND_LIST_TIME_KEY, friendListTime);
    });
  }

  getFriendListTimeFromSharedPref(SharedPreferences prefs) async {
    String friendListTime = prefs.getString(FRIEND_LIST_TIME_KEY);
    this._lastFetchedTime = DateTime.parse(friendListTime);
  }
}
