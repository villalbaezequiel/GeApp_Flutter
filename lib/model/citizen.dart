class Citizen {
  int? id;
  String? nationalId;
  String? first;
  String? last;
  String? birthday;
  int? friendsQty;
  String? createdAt;
  String? updatedAt;
  int? age;

  Citizen(
      {this.id,
      this.nationalId,
      this.first,
      this.last,
      this.birthday,
      this.friendsQty,
      this.createdAt,
      this.updatedAt,
      this.age});

  Citizen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nationalId = json['nationalId'];
    first = json['first'];
    last = json['last'];
    birthday = json['birthday'];
    friendsQty = json['friendsQty'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nationalId'] = this.nationalId;
    data['first'] = this.first;
    data['last'] = this.last;
    data['birthday'] = this.birthday;
    data['friendsQty'] = this.friendsQty;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['age'] = this.age;
    return data;
  }

  factory Citizen.fromString(Map<String, dynamic> json) {
    return Citizen(
      id: json['id'],
      nationalId: json['nationalId'],
      first: json['first'],
      last: json['last'],
      birthday: json['birthday'],
      friendsQty: json['friendsQty'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      age: json['age'],
    );
  }
}
