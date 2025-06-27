import 'package:appcore/external.dart';
import 'package:appcore/shared_provider/user/data/datasource/local/user_local.datasource.dart';
import 'package:appcore/shared_provider/user/data/datasource/remote/user_remote.datasource.dart';
import 'package:appcore/shared_provider/user/data/repository/user.irepository.dart';
import 'package:appcore/shared_provider/user/domain/repositories/user.repositories.dart';

class RepositoryInjector {
  static register(GetIt locator) {
    locator.registerLazySingleton<UserIRepository>(
      () => UserRepository(
        locator<UserRemoteDataSource>(),
        locator<UserLocalDataSource>(),
      ),
    );
  }
}
