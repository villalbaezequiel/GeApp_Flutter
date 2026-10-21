import 'voter.dart';

class VotingTable {
  int? id;
  String? table;
  String? address;
  String? establishment;
  String? section;
  String? circuit;
  String? district;
  bool? isOpen;
  int? replenishQty;
  String? notes;
  String? scrutinyPath;
  int? sumVotes;
  String? createdAt;
  String? updatedAt;
  int? electionId;
  List<Voter>? voters;

  VotingTable(
      {this.id,
      this.table,
      this.address,
      this.establishment,
      this.section,
      this.circuit,
      this.district,
      this.isOpen,
      this.replenishQty,
      this.notes,
      this.scrutinyPath,
      this.sumVotes,
      this.createdAt,
      this.updatedAt,
      this.electionId,
      this.voters});

  VotingTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    table = json['table'];
    address = json['address'];
    establishment = json['establishment'];
    section = json['section'];
    circuit = json['circuit'];
    district = json['district'];
    isOpen = json['isOpen'];
    replenishQty = json['replenishQty'];
    notes = json['notes'];
    scrutinyPath = json['scrutinyPath'];
    sumVotes = json['sumVotes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    electionId = json['electionId'];
    if (json['voters'] != null) {
      voters = <Voter>[];
      json['voters'].forEach((v) {
        voters!.add(Voter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['table'] = this.table;
    data['address'] = this.address;
    data['establishment'] = this.establishment;
    data['section'] = this.section;
    data['circuit'] = this.circuit;
    data['district'] = this.district;
    data['isOpen'] = this.isOpen;
    data['replenishQty'] = this.replenishQty;
    data['notes'] = this.notes;
    data['scrutinyPath'] = this.scrutinyPath;
    data['sumVotes'] = this.sumVotes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['electionId'] = this.electionId;
    if (this.voters != null) {
      data['voters'] = this.voters!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  factory VotingTable.fromString(Map<String, dynamic> json) {
    List<Voter> _voters = [];

    if (json['voters'] != null) {
      json['voters'].forEach((v) {
        _voters.add(Voter.fromString(v));
      });
    }
    return VotingTable(
      id: json['id'],
      table: json['table'],
      address: json['address'],
      establishment: json['establishment'],
      section: json['section'],
      circuit: json['circuit'],
      district: json['district'],
      isOpen: json['isOpen'],
      replenishQty: json['replenishQty'],
      notes: json['notes'],
      scrutinyPath: json['scrutinyPath'],
      sumVotes: json['sumVotes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      electionId: json['electionId'],
      voters: _voters,
    );
  }
}
