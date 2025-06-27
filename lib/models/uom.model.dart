class UomCategoryModel {
  String? id;
  String? name;
  String? code;
  String? icon;
  List<UomModel>? uoms;

  UomCategoryModel({this.id, this.name, this.code, this.icon, this.uoms});

  UomCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    icon = json['icon'];
    if (json['uoms'] != null) {
      uoms = <UomModel>[];
      json['units'].forEach((v) {
        uoms!.add(UomModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['icon'] = icon;
    if (uoms != null) {
      data['units'] = uoms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UomModel {
  String? id;
  String? name;
  String? abbreviation;
  String? categoryId;
  UomCategoryModel? category;
  String? baseUnitId;
  double? toBase;

  UomModel(
      {this.id,
      this.name,
      this.abbreviation,
      this.categoryId,
      this.category,
      this.baseUnitId,
      this.toBase});

  UomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    abbreviation = json['abbreviation'];
    categoryId = json['category_id'];
    category = json['category'] != null
        ? UomCategoryModel.fromJson(json['category'])
        : null;
    baseUnitId = json['base_unit_id'];
    toBase = json['to_base'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['abbreviation'] = abbreviation;
    data['category_id'] = categoryId;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['base_unit_id'] = baseUnitId;
    data['to_base'] = toBase;
    return data;
  }
}
