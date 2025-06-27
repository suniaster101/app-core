import 'package:appcore/core.dart';
import 'package:appcore/external.dart';
import 'package:appcore/shared_provider/user/data/datasource/local/user_local.datasource.dart';
import 'package:appcore/shared_provider/user/data/datasource/remote/user_remote.datasource.dart';

class DatasourceInjector {
  static register(GetIt locator) {
    locator.registerLazySingleton(
      () => UserRemoteDataSource(locator<Rest>()),
    );
    locator.registerLazySingleton(
      () => UserLocalDataSource(locator<DbContext>().isar),
    );
  }
}
