import 'package:appcore/external.dart';
import 'package:appcore/shared_provider/user/application/injector/datasource.injector.dart';
import 'package:appcore/shared_provider/user/application/injector/repository.injector.dart';
import 'package:appcore/shared_provider/user/application/injector/usecase.injector.dart';
import 'package:appcore/shared_provider/user/data/provider/user_provider.dart';
import 'package:appcore/shared_provider/user/domain/usecases/user.usecase.dart';

class UserServiceInjector {
  static dependencies(GetIt locator) {
    DatasourceInjector.register(locator);
    RepositoryInjector.register(locator);
    UsecaseInjector.register(locator);
  }

  static UserProvider provider(GetIt locator) {
    return UserProvider(
      locator<UpdateUserUsecase>(),
      locator<GetMeUsecase>(),
      locator<UpdateCurrentUserImageUsecase>(),
      locator<LogoutUsecase>(),
    );
  }
}
