import 'package:appcore/core.dart';
import 'package:either_dart/either.dart';
import 'package:isar/isar.dart';

// export 'package:easy_localization/easy_localization.dart';
export 'package:either_dart/either.dart';
export 'package:geolocator/geolocator.dart';
export 'package:get_it/get_it.dart';
export 'package:go_router/go_router.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:http/http.dart';
export 'package:isar/isar.dart';
export 'package:provider/provider.dart';
export 'package:url_launcher/url_launcher.dart';

abstract class DbContext {
  late Isar _isar;
  Isar get isar => _isar;
  Future init();
}

extension EitherExtension on Either<Failure, dynamic> {
  resolve(Function(dynamic)? fnR) {
    return fold((l) {
      App.showErrorToast(title: l.message, description: l.description);
    }, (r) {
      if (r is String) {
        App.showSuccessToast(title: r);
      }
      if (fnR != null) {
        return fnR(r);
      }
    });
  }
}
