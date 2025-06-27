import 'dart:io';

import 'package:appcore/core.dart';
import 'package:appcore/shared_provider/user/data/constant/endpoints.dart';
import 'package:appcore/shared_provider/user/data/dto/user.dto.dart';

class UserRemoteDataSource {
  final Rest _rest;
  UserRemoteDataSource(this._rest);

  Future<UserDto?> updateUser({
    required String fullName,
    required String phoneNumber,
    required String birthDate,
    String? referralCode,
  }) async {
    final url = Endpoint.v1.me;
    final data = {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'birth_date': birthDate,
    };

    if (referralCode != null) {
      data["referral_code"] = referralCode;
    }

    final response = await _rest.put(url, data: data);
    if (response?.data["data"] != null) {
      return UserDto.fromJson(response?.data["data"]);
    }
    return null;
  }

  Future<UserDto?> getUserDetails() async {
    final url = Endpoint.v1.me;
    final response = await _rest.get(url);
    if (response?.data["data"] != null) {
      return UserDto.fromJson(response?.data["data"]);
    }
    return null;
  }

  Future<bool> updateCurrentUserImage({required File image}) async {
    final url = Endpoint.v1.me;
    final res = await _rest.patch(url, files: {
      "image": [image]
    }, data: {});
    if (res?.data["data"] != null) {
      return true;
    }
    return false;
  }

  Future<String> userLogout() async {
    final url = Endpoint.v1.userLogout;
    final response = await _rest.post(url, data: {});
    return response?.data["message"] ?? '';
  }
}
