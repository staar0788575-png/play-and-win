import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _init();
  }

  final AuthRepository _repo = AuthRepository.instance;

  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;
  bool _initialized = false;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _userModel != null;
  bool get initialized => _initialized;

  void _init() {
    _repo.authStateChanges.listen((user) async {
      if (user != null) {
        await _loadUserModel(user.uid);
      } else {
        _userModel = null;
        notifyListeners();
      }
      _initialized = true;
      notifyListeners();
    });
  }

  Future<void> _loadUserModel(String uid) async {
    _repo.userStream(uid).listen((model) {
      _userModel = model;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userModel = await _repo.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String username) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userModel = await _repo.signUp(
        email: email,
        password: password,
        username: username,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    _userModel = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _repo.resetPassword(email);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
