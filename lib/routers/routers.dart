import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'package:go_router/go_router.dart';

export 'guards.dart';

class Routes {
  static const splashScreen = "/splash-screen";
  // Main
  static const myBusinessesScreen = "/my-businesses";
  static const emptyBusinessScreen = "/empty-businesses";
  static const createBusiness = "/create-businesses";
  static const dashboard = "/dashboard";
  static const outlets = "/business_outlets";
  static const employees = "/business_employees";
  static const customers = "/customers";
  static const pos = "/pos";
  static const posBarcodeScanner = "/pos/scanner";
  static const reports = "/reports";
  static const supports = "/supports";
  static const subscriptions = "/subscriptions";
  static const promotions = "/promotions";
  static const categories = "/inventory_categories";
  static const additionals = "/inventory_additionals";
  static const modifiers = "/inventory_modifiers";
  static const ingredients = "/inventory_ingredients";
  static const products = "/inventory_products";
  static const bundles = "/inventory_bundles";
  static const settings = "/settings";
  static const profileAdminSetting = "/profile-admin-setting";

  // Auth
  static const String otp = '/auth/otp';
  static const String signIn = '/auth/sign-in';
  static const String onboarding = '/onboarding';
  static const String signUp = '/auth/sign-up';
  static const String resetPassword = '/auth/reset-password';
  static const String signUpCompletion = '/auth/sign-up-completion';
}

final _mainShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "mainShellNavigator");

extension GoRouterLocation on GoRouter {
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}

extension RouterExtension on BuildContext {
  Future<T?> pushTo<T extends Object?>(String location, {Object? extra}) {
    if (GoRouter.of(this).location != location) {
      final currentSegments = GoRouter.of(this).location.split('/');
      final newSegments = location.split('/');
      final currentLocation = currentSegments
          .sublist(0, currentSegments.length - 1)
          .join("/")
          .toLowerCase();
      final newLocation = newSegments
          .sublist(0, newSegments.length - 1)
          .join("/")
          .toLowerCase();

      if (currentLocation == newLocation) {
        return GoRouter.of(this).replace<T?>(location, extra: extra);
      } else {
        return push(location, extra: extra);
      }
    }
    return GoRouter.of(this).replace<T?>(location, extra: extra);
  }

  Future<T?> pushAppendTo<T extends Object?>(String location,
      {Object? extra}) async {
    return await push(GoRouter.of(this).location + location, extra: extra);
  }

  String get currentLocation => GoRouter.of(this).location;
}

Widget _transitionsBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = Offset(1.0, 0.0); // Changed to -1.0 for left to right slide
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);
  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

Widget _scaleTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  var scaleAnimation = Tween<double>(
    begin: 0.75,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: Curves.easeInOut,
  ));
  var fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(animation);

  return ScaleTransition(
    scale: scaleAnimation,
    child: FadeTransition(
      opacity: fadeAnimation,
      child: child,
    ),
  );
}

class RouteDetail {
  final Widget Function(BuildContext context, GoRouterState state) child;
  final Map<String, RouteDetail>? routes;
  RouteDetail({
    required this.child,
    this.routes,
  });
}

RouteBase nestedRouteBuilder(String path, RouteDetail route,
    {bool isRoot = true, bool isRootBranch = false, String? fullPath}) {
  if (route.routes?.isEmpty ?? true) {
    return GoRoute(
      path: path,
      parentNavigatorKey: isRoot ? _mainShellNavigatorKey : null,
      // redirect: Guards.validateAccess,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            context.pop();
          },
          child: route.child(context, state),
        ),
        transitionsBuilder:
            isRoot ? _scaleTransitionsBuilder : _transitionsBuilder,
      ),
    );
  }
  return GoRoute(
    path: path,
    // redirect: Guards.validateAccess,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: route.child(context, state),
      transitionsBuilder:
          isRoot ? _scaleTransitionsBuilder : _transitionsBuilder,
    ),
    routes: route.routes!.entries.map(
      (e) {
        return nestedRouteBuilder(
          e.key,
          e.value,
          isRootBranch: route.routes?.isNotEmpty ?? false,
          isRoot: false,
          fullPath: "${fullPath ?? path}/${e.key}",
        );
      },
    ).toList(),
  );
}
