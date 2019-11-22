import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/person.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/constant.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

mixin FriendService on Model {
  List<Person> _friendsList = [];
  List<Person> get friendsList => _friendsList;

  bool _isLoadingFriends = false;
  bool get isLoadingFriends => _isLoadingFriends;

  int get friendsCount => _friendsList.length;

  CommonWidgest commonWidgests = CommonWidgest();

  Future<List<Person>> fetchFriends(MainModel model) async {
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
//      print(responseData);

        final List<Person> fetchedEvents = [];
        responseData.forEach((dynamic json) {
          if (responseData != null) {
            Person friend = Person.fromJson(json);

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
    } catch (e) {
      if (e is SocketException) {
        commonWidgests.showToast('Sin conexión, por favor intente luego');
      } else {
        commonWidgests.showToast(e.message);
      }
      return [];
      notifyListeners();
    }
  }
}
