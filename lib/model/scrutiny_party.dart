class ScrutinyParty {
  int id;
  String name;
  int scrutinycategoryId;

  ScrutinyParty({this.id, this.name, this.scrutinycategoryId});

  ScrutinyParty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    scrutinycategoryId = json['scrutinycategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['scrutinycategoryId'] = this.scrutinycategoryId;
    return data;
  }

  factory ScrutinyParty.fromString(Map<String, dynamic> json) {
    return ScrutinyParty(
      id: json['id'],
      name: json['name'],
      scrutinycategoryId: json['scrutinycategoryId'],
    );
  }
}
