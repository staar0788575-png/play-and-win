import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository._();

  static final AuthRepository instance = AuthRepository._();

  final AuthService _authService = AuthService.instance;

  User? get currentUser => _authService.currentUser;
  Stream<User?> get authStateChanges => _authService.authStateChanges();

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  }) {
    return _authService.signUp(email: email, password: password, username: username);
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) {
    return _authService.signIn(email: email, password: password);
  }

  Future<void> signOut() => _authService.signOut();

  Future<void> resetPassword(String email) => _authService.resetPassword(email);

  Future<UserModel?> getCurrentUserModel() => _authService.getCurrentUserModel();

  Stream<UserModel?> userStream(String userId) => _authService.userStream(userId);
}
