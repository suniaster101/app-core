import 'package:appcore/external.dart';
import 'package:appcore/services/services.dart';
import 'package:appcore/shared_provider/user/data/repository/user.irepository.dart';
import 'package:appcore/shared_provider/user/domain/usecases/user.usecase.dart';

class UsecaseInjector {
  static register(GetIt locator) {
    locator.registerLazySingleton(
      () => UpdateUserUsecase(
        locator<UserIRepository>(),
        locator<UserService>(),
      ),
    );
    locator.registerLazySingleton(
      () => GetMeUsecase(
        locator<UserIRepository>(),
        locator<UserService>(),
      ),
    );
    locator.registerLazySingleton(
      () => UpdateCurrentUserImageUsecase(
        locator<UserIRepository>(),
      ),
    );
    locator.registerLazySingleton(
      () => LogoutUsecase(
        locator<UserIRepository>(),
        locator<Session>(),
      ),
    );
  }
}
