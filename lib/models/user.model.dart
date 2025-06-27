import 'package:appcore/external.dart';

part 'user.model.g.dart';

@collection
class UserModel {
  Id? id = Isar.autoIncrement;
  String? birthDate;
  List<BusinessModel>? businesses;
  String? email;

  String? image;
  String? name;
  String? phoneNumber;
  List<String>? referee;
  String? referral;
  int? referrerId;
  int? status;

  UserModel(
      {this.birthDate,
      this.businesses,
      this.email,
      this.id,
      this.image,
      this.name,
      this.phoneNumber,
      this.referee,
      this.referral,
      this.referrerId,
      this.status});
}

@embedded
class BusinessModel {
  String? address;
  String? birthDate;
  String? businessType;
  List<DepartmentModel>? departments;
  int? id;
  String? image;
  int? latitude;
  int? longitude;
  String? name;
  int? ownerId;
  String? phoneNumber;

  BusinessModel(
      {this.address,
      this.birthDate,
      this.businessType,
      this.departments,
      this.id,
      this.image,
      this.latitude,
      this.longitude,
      this.name,
      this.ownerId,
      this.phoneNumber});
}

@embedded
class DepartmentModel {
  int? businessId;
  String? departmentType;
  int? id;
  bool? isActive;
  String? name;
  RoleModel? roles;

  DepartmentModel(
      {this.businessId,
      this.departmentType,
      this.id,
      this.isActive,
      this.name,
      this.roles});
}

@embedded
class RoleModel {
  String? name;
  List<PermissionModel>? permissions;

  RoleModel({this.name, this.permissions});
}

@embedded
class PermissionModel {
  int? id;
  String? name;
  String? permissionType;

  PermissionModel({this.id, this.name, this.permissionType});
}
