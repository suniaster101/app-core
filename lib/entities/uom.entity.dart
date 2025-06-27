class UomCategoryEntity {
  String? id;
  String? name;
  String? code;
  String? icon;
  List<UomEntity>? uoms;

  UomCategoryEntity({this.id, this.name, this.code, this.icon, this.uoms});

  UomCategoryEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    icon = json['icon'];
    if (json['uoms'] != null) {
      uoms = <UomEntity>[];
      json['units'].forEach((v) {
        uoms!.add(UomEntity.fromJson(v));
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

class UomEntity {
  String? id;
  String? name;
  String? abbreviation;
  String? categoryId;
  UomCategoryEntity? category;
  String? baseUnitId;
  double? toBase;

  UomEntity(
      {this.id,
      this.name,
      this.abbreviation,
      this.categoryId,
      this.category,
      this.baseUnitId,
      this.toBase});

  UomEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    abbreviation = json['abbreviation'];
    categoryId = json['category_id'];
    category = json['category'] != null
        ? UomCategoryEntity.fromJson(json['category'])
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
