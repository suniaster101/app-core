import 'package:appcore/entities/user.entity.dart';
import 'package:flutter/material.dart';

class UserService with ChangeNotifier {
  UserEntity? _currentUser;

  UserEntity? get currentUser => _currentUser;

  void setCurrentUser(UserEntity user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }
}
