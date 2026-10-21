class VoteElection {
  List<Vote>? quantities;
  String? notes;

  VoteElection({
    this.notes,
    this.quantities,
  });

  VoteElection.fromJson(Map<String, dynamic> json) {
    notes = json['notes'];
    if (json['quantities'] != null) {
      quantities = <Vote>[];
      json['quantities'].forEach((v) {
        quantities!.add(Vote.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['notes'] = this.notes;
    if (this.quantities != null) {
      data['quantities'] = this.quantities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vote {
  int? scrutinyPartyId;
  int? qty;

  Vote({
    this.scrutinyPartyId,
    this.qty,
  });

  Vote.fromJson(Map<String, dynamic> json) {
    scrutinyPartyId = int.parse(json['scrutinyPartyId']);
    qty = int.parse(json['qty']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['scrutinyPartyId'] = this.scrutinyPartyId;
    data['qty'] = this.qty;
    return data;
  }
}
