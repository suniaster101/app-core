// 🌎 Project imports:

import 'dart:io';

import 'package:appcore/core.dart';
import 'package:appcore/entities/user.entity.dart';
import 'package:appcore/external.dart';
import 'package:appcore/shared_provider/user/data/datasource/local/user_local.datasource.dart';
import 'package:appcore/shared_provider/user/data/datasource/remote/user_remote.datasource.dart';
import 'package:appcore/shared_provider/user/data/mapper/user.mapper.dart';
import 'package:appcore/shared_provider/user/data/repository/user.irepository.dart';

class UserRepository implements UserIRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  UserRepository(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, UserEntity>> getUserDetails() async {
    try {
      // final localDataSource = AuthLocalDataSource(AppDbContext.i.isar);
      final data = await Synchronizer.fetchData(
        fetchOnline: () {
          return _remoteDataSource.getUserDetails();
        },
        fetchOffline: () {
          return _localDataSource.getUserDetails();
        },
        updateLocalDatabase: (data) {
          return _localDataSource.cacheUser(user: data);
        },
      );
      if (data != null) {
        return Right(UserMapper.toEntity(data));
      }
      return Left(Failure(message: "User not found"));
    } on Exception catch (e) {
      return Left(Failure.fromError(e));
    }
  }

  // @override
  // Future<UserDto?> completeUserDetails(
  //     {required Map<String, dynamic> data}) async {
  //   final result = await Graphql.instance.mutate(
  //     query: AuthQueries.completeuserDetailsMutation,
  //     action: "completeUserDetails",
  //     data: data,
  //     parser: (data) => UserDto.fromJson(data),
  //   );

  //   return result;
  // }

  @override
  Future<Either<Failure, UserEntity>> updateUser({
    required String fullName,
    required String phoneNumber,
    required String birthDate,
    String? referralCode,
  }) async {
    try {
      final result = await _remoteDataSource.updateUser(
        fullName: fullName,
        phoneNumber: phoneNumber,
        birthDate: birthDate,
      );
      if (result == null) {
        return Left(Failure(message: "not found"));
      }
      return Right(UserMapper.toEntity(result));
    } on Exception catch (e) {
      return Left(Failure.fromError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> updateCurrentUserImage({
    required File image,
  }) async {
    try {
      final res = await _remoteDataSource.updateCurrentUserImage(
        image: image,
      );
      return Right(res);
    } on Exception catch (e) {
      return Left(Failure.fromError(e));
    }
  }

  @override
  Future<Either<Failure, String>> userLogout() async {
    try {
      final result = await _remoteDataSource.userLogout();

      return Right(result);
    } on Exception catch (e) {
      return Left(Failure.fromError(e));
    }
  }
}
