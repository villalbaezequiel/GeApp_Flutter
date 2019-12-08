import 'scrutiny_party.dart';

class ScrutinyCategory {
  int id;
  String name;
  int electionId;
  List<ScrutinyParty> scrutinyparties;

  ScrutinyCategory({this.id, this.name, this.electionId, this.scrutinyparties});

  ScrutinyCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    electionId = json['electionId'];
    if (json['scrutinyparties'] != null) {
      scrutinyparties = List<ScrutinyParty>();
      json['scrutinyparties'].forEach((v) {
        scrutinyparties.add(ScrutinyParty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['electionId'] = this.electionId;
    if (this.scrutinyparties != null) {
      data['scrutinyparties'] =
          this.scrutinyparties.map((v) => v.toJson()).toList();
    }
    return data;
  }

  factory ScrutinyCategory.fromString(Map<String, dynamic> json) {
    List<ScrutinyParty> _scrutinyparties = [];

    if (json['scrutinyparties'] != null) {
      json['scrutinyparties'].forEach((v) {
        _scrutinyparties.add(ScrutinyParty.fromString(v));
      });
    }
    return ScrutinyCategory(
      id: int.parse(json['id']),
      name: json['name'],
      electionId: int.parse(json['electionId']),
      scrutinyparties: _scrutinyparties,
    );
  }
}
