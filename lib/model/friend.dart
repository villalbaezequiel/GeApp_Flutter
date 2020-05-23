import 'citizen.dart';

class Friend {
  int id;
  String phone;
  String email;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  int userId;
  int citizenId;
  Citizen citizen;

  Friend(
      {this.id,
      this.phone,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.userId,
      this.citizenId,
      this.citizen});

  Friend.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    userId = json['userId'];
    citizenId = json['citizenId'];
    citizen =
        json['citizen'] != null ? new Citizen.fromJson(json['citizen']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['userId'] = this.userId;
    data['citizenId'] = this.citizenId;
    if (this.citizen != null) {
      data['citizen'] = this.citizen.toJson();
    }
    return data;
  }

  factory Friend.fromString(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      phone: json['phone'],
      email: json['email'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      userId: json['userId'],
      citizenId: json['citizenId'],
      citizen:
          json['citizen'] != null ? Citizen.fromString(json['citizen']) : null,
    );
  }
}
