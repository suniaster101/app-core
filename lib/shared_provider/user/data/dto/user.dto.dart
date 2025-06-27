class UserDto {
  int? id;
  String? birthDate;
  List<BusinessDto>? businesses;
  List<BusinessDto>? workspaces;
  String? email;
  String? image;
  String? name;
  String? phoneNumber;
  List<String>? referee;
  String? referral;
  int? referrerId;
  int? status;

  UserDto(
      {this.birthDate,
      this.businesses,
      this.workspaces,
      this.email,
      this.id,
      this.image,
      this.name,
      this.phoneNumber,
      this.referee,
      this.referral,
      this.referrerId,
      this.status});

  UserDto.fromJson(Map<String, dynamic> json) {
    birthDate = json['birth_date'];
    if (json['businesses'] != null) {
      businesses = <BusinessDto>[];
      json['businesses'].forEach((v) {
        businesses!.add(BusinessDto.fromJson(v));
      });
    }
    if (json['workspaces'] != null) {
      workspaces = <BusinessDto>[];
      json['workspaces'].forEach((v) {
        workspaces!.add(BusinessDto.fromJson(v));
      });
    }
    email = json['email'];
    id = json['id'];
    image = json['image'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    referee = json['referee'];
    referral = json['referral'];
    referrerId = json['referrer_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['birth_date'] = birthDate;
    if (businesses != null) {
      data['businesses'] = businesses!.map((v) => v.toJson()).toList();
    }
    if (workspaces != null) {
      data['workspaces'] = workspaces!.map((v) => v.toJson()).toList();
    }
    data['email'] = email;
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['referee'] = referee;
    data['referral'] = referral;
    data['referrer_id'] = referrerId;
    data['status'] = status;
    return data;
  }
}

class BusinessDto {
  String? address;
  String? birthDate;
  String? businessType;
  List<DepartmentDto>? departments;
  int? id;
  String? image;
  int? latitude;
  int? longitude;
  String? name;
  int? ownerId;
  String? phoneNumber;

  BusinessDto(
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

  BusinessDto.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    birthDate = json['birth_date'];
    businessType = json['business_type'];
    if (json['departments'] != null) {
      departments = <DepartmentDto>[];
      json['departments'].forEach((v) {
        departments!.add(DepartmentDto.fromJson(v));
      });
    }
    id = json['id'];
    image = json['image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];
    ownerId = json['owner_id'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['birth_date'] = birthDate;
    data['business_type'] = businessType;
    if (departments != null) {
      data['departments'] = departments!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['image'] = image;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['name'] = name;
    data['owner_id'] = ownerId;
    data['phone_number'] = phoneNumber;
    return data;
  }
}

class DepartmentDto {
  int? businessId;
  String? departmentType;
  int? id;
  bool? isActive;
  String? name;
  RoleDto? roles;

  DepartmentDto(
      {this.businessId,
      this.departmentType,
      this.id,
      this.isActive,
      this.name,
      this.roles});

  DepartmentDto.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    departmentType = json['department_type'];
    id = json['id'];
    isActive = json['is_active'];
    name = json['name'];
    roles = json['roles'] != null ? RoleDto.fromJson(json['roles']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_id'] = businessId;
    data['department_type'] = departmentType;
    data['id'] = id;
    data['is_active'] = isActive;
    data['name'] = name;
    if (roles != null) {
      data['roles'] = roles!.toJson();
    }
    return data;
  }
}

class RoleDto {
  String? name;
  List<PermissionDto>? permissions;

  RoleDto({this.name, this.permissions});

  RoleDto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['permissions'] != null) {
      permissions = <PermissionDto>[];
      json['permissions'].forEach((v) {
        permissions!.add(PermissionDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PermissionDto {
  int? id;
  String? name;
  String? permissionType;

  PermissionDto({this.id, this.name, this.permissionType});

  PermissionDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    permissionType = json['permission_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['permission_type'] = permissionType;
    return data;
  }
}
