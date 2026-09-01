import 'package:mt/features/auth/domain/repository/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepoImpl implements AuthRepo {
  final SupabaseClient _client;
  AuthRepoImpl(this._client);

  @override
  /*
    onAuthStateChange => Stream<AuthState> objects
    map() => transfers Stream<AuthState> objects to Stream<bool> to be used by router
  */
  Stream<bool> get authStateChange =>
      _client.auth.onAuthStateChange.map((data) => data.session != null);

  @override
  bool get isLoggedIn => _client.auth.currentSession != null;
}
