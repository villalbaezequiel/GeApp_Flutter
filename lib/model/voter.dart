import 'citizen.dart';

class Voter {
  int id;
  int order;
  bool voted;
  bool isOwner;
  String createdAt;
  String updatedAt;
  int citizenId;
  int votingtableId;
  Citizen citizen;
  String address;

  Voter({
    this.id,
    this.order,
    this.voted,
    this.isOwner,
    this.createdAt,
    this.updatedAt,
    this.citizenId,
    this.votingtableId,
    this.address,
    this.citizen,
  });

  Voter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    order = int.parse(json['order']);
    voted = json['voted'];
    isOwner = json['isOwner'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    citizenId = json['citizenId'];
    votingtableId = json['votingtableId'];
    address = json['address'];
    citizen =
        json['citizen'] != null ? new Citizen.fromJson(json['citizen']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order'] = this.order.toString();
    data['voted'] = this.voted;
    data['isOwner'] = this.isOwner;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['citizenId'] = this.citizenId;
    data['votingtableId'] = this.votingtableId;
    data['address'] = this.address;
    if (this.citizen != null) {
      data['citizen'] = this.citizen.toJson();
    }
    return data;
  }
}
