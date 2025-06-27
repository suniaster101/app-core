// 🐦 Flutter imports:
import 'dart:io';

import 'package:appcore/core.dart';
import 'package:appcore/entities/user.entity.dart';
import 'package:appcore/external.dart';
import 'package:appcore/shared_provider/user/domain/usecases/user.usecase.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final UpdateUserUsecase _updateUserUsecase;
  final GetMeUsecase _getMeUsecase;
  final UpdateCurrentUserImageUsecase _updateCurrentUserImageUsecase;
  final LogoutUsecase _logoutUsecase;

  UserEntity me = UserEntity();

  UserProvider(
    this._updateUserUsecase,
    this._getMeUsecase,
    this._updateCurrentUserImageUsecase,
    this._logoutUsecase,
  );

  Future<Either<Failure, UserEntity>> updateUser({
    required String fullName,
    required String phoneNumber,
    required String birthDate,
    String? referralCode,
  }) async {
    final res = await _updateUserUsecase.call(
      fullName: fullName,
      birthDate: birthDate,
      phoneNumber: phoneNumber,
      referralCode: referralCode,
    );

    if (res.isRight) {
      me = res.right;
      notifyListeners();
    }
    return res;
  }

  Future<Either<Failure, UserEntity>> getMe() async {
    final res = await _getMeUsecase.call();
    if (res.isRight) {
      me = res.right;
      notifyListeners();
    }
    return res;
  }

  Future<Either<Failure, bool>> updateCurrentUserImage({
    required File image,
  }) async {
    return await _updateCurrentUserImageUsecase.call(image: image);
  }

  Future<Either<Failure, bool>> logout() async {
    return await _logoutUsecase.call();
  }
}
