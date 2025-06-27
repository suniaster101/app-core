class UserEntity {
  int? id;
  String? birthDate;
  //List<Business>? businesses;
  String? email;

  String? image;
  String? name;
  String? phoneNumber;
  List<String>? referee;
  String? referral;
  int? referrerId;
  int? status;

  UserEntity(
      {this.birthDate,
      //  this.businesses,
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

class Business {
  String? address;
  String? birthDate;
  String? businessType;
  List<Department>? departments;
  int? id;
  String? image;
  int? latitude;
  int? longitude;
  String? name;
  int? ownerId;
  String? phoneNumber;

  Business(
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

class Department {
  int? businessId;
  String? departmentType;
  int? id;
  bool? isActive;
  String? name;
  Role? roles;

  Department(
      {this.businessId,
      this.departmentType,
      this.id,
      this.isActive,
      this.name,
      this.roles});
}

class Role {
  String? name;
  List<Permission>? permissions;

  Role({this.name, this.permissions});
}

class Permission {
  int? id;
  String? name;
  String? permissionType;

  Permission({this.id, this.name, this.permissionType});
}
