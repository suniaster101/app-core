import 'dart:io';

import 'package:appcore/core.dart';
import 'package:appcore/entities/user.entity.dart';
import 'package:appcore/external.dart';
import 'package:appcore/shared_provider/user/data/dto/user.dto.dart';
import 'package:appcore/shared_provider/user/data/repository/user.irepository.dart';

class UpdateUserUsecase {
  final UserService _userService;
  final UserIRepository _repository;

  UpdateUserUsecase(this._repository, this._userService);

  Future<Either<Failure, UserEntity>> call({
    required String fullName,
    required String phoneNumber,
    required String birthDate,
    String? referralCode,
  }) async {
    final result = await _repository.updateUser(
      fullName: fullName,
      birthDate: birthDate,
      phoneNumber: phoneNumber,
      referralCode: referralCode,
    );
    if (result.isRight) {
      _userService.setCurrentUser(result.right);
      return Right(result.right);
    }

    return Left(result.left);
  }
}

class GetMeUsecase {
  final UserIRepository _repository;
  final UserService _userService;
  GetMeUsecase(this._repository, this._userService);
  Future<Either<Failure, UserEntity>> call({
    Function(UserDto? data)? onFetchComplete,
  }) async {
    final result = await _repository.getUserDetails();
    if (result.isRight) {
      _userService.setCurrentUser(result.right);
      return Right(result.right);
    }
    return Left(result.left);
  }
}

class UpdateCurrentUserImageUsecase {
  final UserIRepository _repository;
  UpdateCurrentUserImageUsecase(this._repository);
  Future<Either<Failure, bool>> call({
    required File image,
  }) async {
    final result = await _repository.updateCurrentUserImage(image: image);
    if (result.isRight) {
      return const Right(true);
    }
    return Left(result.left);
  }
}

class LogoutUsecase {
  final UserIRepository _repository;
  final Session _session;
  LogoutUsecase(this._repository, this._session);
  Future<Either<Failure, bool>> call() async {
    final result = await _repository.userLogout();
    if (result.isRight) {
      await _session.logout();
      return const Right(true);
    }
    return Left(result.left);
  }
}
