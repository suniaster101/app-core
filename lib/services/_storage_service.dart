// // 📦 Package imports:
// import 'package:get_storage/get_storage.dart';

// class Storage {
//   static const _api = 'api_actions';
//   static const _cache = 'cached_response';
//   static const _core = 'core';
//   static const _sync = 'sync';
//   static GetStorage core = GetStorage(_core);
//   static GetStorage cache = GetStorage(_cache);
//   static GetStorage api = GetStorage(_api);
//   static GetStorage sync = GetStorage(_sync);

//   static Future<void> init() async {
//     await GetStorage.init(_cache);
//     await GetStorage.init(_api);
//     await GetStorage.init(_sync);
//   }

//   static Future<void> removeContainer({required String container}) async {
//     await GetStorage(container).erase();
//   }

//   static Future<void> erase() async {
//     await GetStorage().erase();
//   }
// }
