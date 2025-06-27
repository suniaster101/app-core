// 🐦 Flutter imports:
import 'package:appcore/core.dart';
import 'package:appcore/routers/routers.dart';
import 'package:flutter/material.dart';
// 📦 Package imports:

class Guards {
  static final Map<String, String> _mapAccess = {
    Routes.outlets: 'read',
    "${Routes.outlets}/details": 'read',
    "${Routes.outlets}/create": 'write',
    "${Routes.outlets}/delete": 'delete',
  };

  static final Map<String, String? Function(String? access)> _mapValidator = {
    Routes.outlets: (access) => Session.i.isOwner ? null : "/not-permitted",
  };

  /// ```
  /// validate route request based on access (read, write, delete)
  /// ```
  static String? authenticated(BuildContext context, GoRouterState state) {
    return Session.i.isAuthenticated ? null : Routes.signIn;
  }

  static String? validateAccess(BuildContext context, GoRouterState state) {
    final access = _mapAccess[state.path];
    return _mapValidator[state.path]?.call(access);
  }
}
