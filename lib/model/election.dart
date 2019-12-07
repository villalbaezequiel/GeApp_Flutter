import 'package:voting_app/model/scrutiny_category.dart';

class Election {
  int id;
  String name;
  String year;
  String description;
  bool isActive;
  String createdAt;
  String updatedAt;
  List<ScrutinyCategory> scrutinycategories;

  Election({
    this.id,
    this.name,
    this.year,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.scrutinycategories,
  });

  Election.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    year = json['year'];
    description = json['description'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['scrutinycategories'] != null) {
      scrutinycategories = new List<ScrutinyCategory>();
      json['scrutinycategories'].forEach((v) {
        scrutinycategories.add(new ScrutinyCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['year'] = this.year;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.scrutinycategories != null) {
      data['scrutinycategories'] =
          this.scrutinycategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
