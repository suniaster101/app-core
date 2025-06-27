import 'package:appcore/external.dart';
import 'package:appcore/services/_user_service.dart';

export '_fetcher_service.dart';
export '_printer_service.dart';
export '_session_service.dart';
export '_storage_service.dart';
export '_user_service.dart';

class CoreService {
  static dependencies(GetIt locator) {
    locator.registerLazySingleton(
      () => UserService(),
    );
  }
}
