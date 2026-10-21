class Person {
  int? id;
  String? nationalId;
  String? token;
  String? firstName; //extra on login as first
  String? lastName; //extra on login ast last
  String? role;
  bool? approved;
  bool? isOwner;
  String? helpPhone;
  String? email;
  String? phone;

  Person({
    this.id,
    this.nationalId,
    this.token,
    this.role,
    this.approved,
    this.isOwner,
    this.firstName,
    this.lastName,
    this.helpPhone,
    this.email,
    this.phone,
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
      helpPhone: json['helpPhone'],
      email: json['email'],
      phone: json['phone'],
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
      helpPhone: json['helpPhone'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nationalId': nationalId,
        'token': token,
        'role': role,
        'approved': approved,
        'isOwner': isOwner,
        'firstName': firstName,
        'lastName': lastName,
        'helpPhone': helpPhone,
        'email': email,
        'phone': phone,
      };
}
