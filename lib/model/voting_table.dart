import 'voter.dart';

class VotingTable {
  int id;
  String table;
  String address;
  String establishment;
  String section;
  String circuit;
  String district;
  bool isOpen;
  int replenishQty;
  String notes;
  String scrutinyPath;
  int sumVotes;
  String createdAt;
  String updatedAt;
  int electionId;
  List<Voter> voters;

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
      voters = new List<Voter>();
      json['voters'].forEach((v) {
        voters.add(new Voter.fromJson(v));
      });
    }
  }
}
