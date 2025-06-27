import 'dart:io';

import 'package:appcore/core.dart';
import 'package:appcore/entities/user.entity.dart';
import 'package:appcore/external.dart';

abstract class UserIRepository {
  Future<Either<Failure, UserEntity>> getUserDetails();
  Future<Either<Failure, UserEntity>> updateUser({
    required String fullName,
    required String phoneNumber,
    required String birthDate,
    String? referralCode,
  });
  Future<Either<Failure, bool>> updateCurrentUserImage({
    required File image,
  });

  Future<Either<Failure, String>> userLogout();
}
