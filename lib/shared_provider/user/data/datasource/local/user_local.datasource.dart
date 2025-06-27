import 'package:appcore/models/user.model.dart';
import 'package:appcore/shared_provider/user/data/dto/user.dto.dart';
import 'package:appcore/shared_provider/user/data/mapper/user.mapper.dart';
import 'package:isar/isar.dart';

class UserLocalDataSource {
  final Isar _dbContext;
  UserLocalDataSource(this._dbContext);

  Future<UserDto?> getUserDetails() async {
    final user = await _dbContext.userModels.where().findFirst();
    return user != null ? UserMapper.toDto(user) : null;
  }

  Future cacheUser({required UserDto? user}) async {
    if (user != null) {
      await _dbContext.writeTxn(() async {
        await _dbContext.userModels.put(UserMapper.toModel(
          user,
        ));
      });
    }
  }
}
