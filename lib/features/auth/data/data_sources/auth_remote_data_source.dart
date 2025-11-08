import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class IAuthRemoteDataSource {
  Future<User> register({
    required String email,
    required String password,
  });

  Future<User> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();
}

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._supabaseClient);
  final SupabaseClient _supabaseClient;

  @override
  Future<User?> getCurrentUser() async {
    return _supabaseClient.auth.currentUser;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw const AuthException('Invalid credentials');
    }
    return response.user!;
  }

  @override
  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
  }

  @override
  Future<User> register(
      {required String email, required String password}) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw const AuthException('User registration failed');
    }
    return response.user!;
  }
}
