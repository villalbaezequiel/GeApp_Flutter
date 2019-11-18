import 'package:shared_preferences/shared_preferences.dart';

class Person {
  int id;
  String nationalId;
  String token;
  String firstName; //extra on login as first
  String lastName; //extra on login ast last
  String role;
  bool approved;
  bool isOwner;

  Person({
    this.id,
    this.nationalId,
    this.token,
    this.role,
    this.approved,
    this.isOwner,
    this.firstName,
    this.lastName,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      nationalId: json['nationalId'],
      token: json['token'],
      role: json['role'],
      approved: json['approved'],
      isOwner: json['isOwner'],
      firstName: json['first'],
      lastName: json['last'],
    );
  }

  factory Person.fromString(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      nationalId: json['nationalId'],
      token: json['token'],
      role: json['role'],
      approved: json['approved'],
      isOwner: json['isOwner'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': 'id',
        'nationalId': 'nationalId',
        'token': 'token',
        'role': 'role',
        'approved': 'approved',
        'isOwner': 'isOwner',
        'firstName': 'firstName',
        'lastName': 'lastName',
      };

  savePersonToSharedPref(String userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", userData);
  }
}
