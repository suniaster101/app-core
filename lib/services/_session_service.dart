// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:appcore/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class Session {
  static Session get i => GetIt.I<Session>();

  final String _token = 'accessToken';
  final String _login = 'login';
  final String _onboarding = 'onboarding';
  final String _newcomers = 'isNewcomers';
  final String _assistive = 'assistive_';
  final String _offline = 'offline';
  final String _businessId = 'businessId';
  final String _outletId = 'outletId';
  final String _language = 'language';
  final String _permissionKey = 'permission';
  final String _uiModeKey = 'ui_mode'; // dark / light
  Map<String, dynamic> _permission = {};
  final _secureStorage = const FlutterSecureStorage();
  bool isAuthenticated = false;
  bool isNewcomers = true;
  bool isOwner = true;
  bool hideOnboarding = true;
  bool isDarkMode = true;
  String? businessId;
  String? outletId;
  String language = "en";
  double assistivePositionX = 0;
  double assistivePositionY = 0;
  double scaleFactor = 0.95;

  Session._();

  factory Session() {
    return Session._();
  }

  Future<void> setOnboarding() async {
    await _secureStorage.write(key: _onboarding, value: 'true');
  }

  Future<void> setLanguage({String? languageCode}) async {
    language = languageCode ?? "en";
    await _secureStorage.write(key: _language, value: languageCode ?? "en");
  }

  String? checkPermission(BuildContext context, String path) {
    Log.w(path);
    return null;
  }

  bool hasPermission({required String featuresName}) {
    return _permission[featuresName] != null;
  }

  Future<void> reset() async {
    await _secureStorage.deleteAll();
  }

  Future<void> init() async {
    // await _secureStorage.deleteAll();
    // return;

    language = await getString(_language) ?? "en";
    hideOnboarding = await getBool(_onboarding);
    isAuthenticated = (await getBool(_login)) || (await getToken() != null);
    businessId = await getString(_businessId);
    outletId = await getString(_outletId);
    assistivePositionX =
        double.tryParse(await getString("${_assistive}x") ?? "") ?? 0;
    assistivePositionY =
        double.tryParse(await getString("${_assistive}y") ?? "") ?? 0;
    isNewcomers = (await _secureStorage.read(key: _newcomers)) == null;
    _permission = jsonDecode(await getString(_permissionKey) ?? '{}');
    isDarkMode = await getBool(_uiModeKey);
    if (assistivePositionX.toInt() == 0 && assistivePositionY.toInt() == 0) {
      updateAssistivePosition(
          x: (Screen.width - 50) / 2, y: Screen.height - 80);
    }
  }

  Future<void> updateAssistivePosition(
      {required double x, required double y}) async {
    assistivePositionX = x;
    assistivePositionY = y;
    await save("${_assistive}x", x);
    await save("${_assistive}y", y);
  }

  Future<void> updatePermission({required String permissions}) async {
    await save(_permissionKey, permissions);
  }

  Future<void> toggleUIMode() async {
    isDarkMode = !isDarkMode;
    await save(_uiModeKey, isDarkMode);
  }

  Future<bool> getBool(String key) async {
    return (await _secureStorage.read(key: key) ?? '') == 'true';
  }

  Future<String?> getString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> setActiveBusinessOutlet(
      {required String businessId, required String? outletId}) async {
    this.businessId = businessId;
    this.outletId = outletId;
    await Future.wait([
      save(_businessId, businessId),
      if (outletId != null) save(_outletId, outletId)
    ]);
  }

  Future<int?> getInt(String key) async {
    return int.tryParse(await _secureStorage.read(key: key) ?? '');
  }

  Future<void> save(String key, dynamic value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<void> removeKey(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _token);
  }

  Future<bool> isOfflineMode() async {
    return await getBool(_offline);
  }

  Future<void> toggleOfflineMode() async {
    await save(_offline, !(await getBool(_offline)));
  }

  Future<void> saveUserCridentials({required String token}) async {
    isAuthenticated = true;
    // await Future.wait([
    //   save(_token, token),
    //   save(_refreshToken, refreshToken),
    //   save(_login, true),
    //   save(_newcomers, true),
    // ]);
    // Log.i("token $token");
    // Log.i("refreshToken $refreshToken");
    await save(_token, token);
    await save(_login, true);
    await save(_newcomers, true);
    Log.w(await _secureStorage.readAll(
      wOptions: const WindowsOptions(useBackwardCompatibility: false),
    ));
  }

  Future<void> logout() async {
    isAuthenticated = false;
    isNewcomers = true;
    businessId = null;
    outletId = null;
    final rememberMe = await getString('remember-me');
    await _secureStorage.deleteAll();
    if (rememberMe != null) {
      save('remember-me', rememberMe);
    }
  }
}
