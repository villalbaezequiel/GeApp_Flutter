import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/model/friend.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/constant.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin FriendService on Model {
  List<Friend> _friendsList = [];
  List<Friend> get friendsList => _friendsList;

  // this is used for all api call required for friends
  bool _isLoadingFriends = false;

  bool get isLoadingFriends => _isLoadingFriends;

  int get friendsCount => _friendsList.length;

  CommonWidgest commonWidgests = CommonWidgest();

  Future<List<Friend>> fetchFriends(MainModel model) async {
    try {
      _isLoadingFriends = true;
      notifyListeners();

      var response =
          await http.get(Constant.baseUrl + Constant.friends, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user.token}",
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        final List<Friend> fetchedEvents = [];
        responseData.forEach((dynamic json) {
          if (responseData != null) {
            Friend friend = Friend.fromJson(json);

            fetchedEvents.add(friend);
          }
        });

        _friendsList = fetchedEvents;

        print("LENGTH friends: ${_friendsList.length}");
        _isLoadingFriends = false;
        notifyListeners();
      } else {
        _isLoadingFriends = false;
        notifyListeners();
        // throw Exception('failed to load data');
      }
      return _friendsList;
    } catch (error) {
      _isLoadingFriends = false;
      catchExceptions(error);
      return [];
    }
  }

  Future<bool> addFriend(MainModel model, String nationalId, String email,
      String phoneNumber) async {
    try {
      var params = {
        "nationalId": nationalId,
        "email": email,
        "phone": phoneNumber
      };
      _isLoadingFriends = true;
      notifyListeners();

      var body = json.encode(params);
      var response = await http
          .post(Constant.baseUrl + Constant.friends, body: body, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${model.user.token}",
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Friend friend = Friend.fromJson(mapResponse);
        addToFriendsList(friend);
        model.setFriendFetchedTime(DateTime.now());
        _isLoadingFriends = false;
        notifyListeners();
        commonWidgests.showToast("Con éxito amigo añadido.");
        return true;
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);
        commonWidgests.showToast(errors.message);
        _isLoadingFriends = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _isLoadingFriends = false;

      catchExceptions(error);
      return false;
    }
  }

  Future<bool> deleteFriend(MainModel model, Friend person) async {
    try {
      _isLoadingFriends = true;
      notifyListeners();

      var response = await http.delete(
          Constant.baseUrl + Constant.friends + person.id.toString(),
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "Bearer ${model.user.token}",
          });

      if (response.statusCode == 200) {
        removeFromFriendsList(person);
        _isLoadingFriends = false;
        notifyListeners();
        return true;
      } else {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        Errors errors = new Errors.fromJson(mapResponse['errors']);
        commonWidgests.showToast(errors.message);
        _isLoadingFriends = false;
        notifyListeners();
        // throw Exception('failed to load data');
        return false;
      }
    } catch (error) {
      _isLoadingFriends = false;
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

  addToFriendsList(Friend person) {
    var existingItem = _friendsList.firstWhere(
        (itemToCheck) => (itemToCheck.id == person.id),
        orElse: () => null);
    if (existingItem == null) {
      this._friendsList.add(person);
    }
  }

  /// Remove the entry and save to disk.
  removeFromFriendsList(Friend person) {
    var existingItem = _friendsList.firstWhere(
        (itemToCheck) => (itemToCheck.id == person.id),
        orElse: () => null);
    if (existingItem != null) {
      this._friendsList.remove(existingItem);
    }
  }

  clearFriendList() {
    this._friendsList = null;
  }
}
