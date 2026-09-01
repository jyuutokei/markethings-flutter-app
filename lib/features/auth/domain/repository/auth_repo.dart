abstract class AuthRepo {
  Stream<bool> get authStateChange;
  bool get isLoggedIn;
}
