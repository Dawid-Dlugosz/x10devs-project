import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:x10devs/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(this._authRemoteDataSource);
  final IAuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await _authRemoteDataSource.getCurrentUser();
      return right(user);
    } on AuthException catch (e) {
      return left(Failure.authFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> login(
      {required String email, required String password}) async {
    try {
      final user =
          await _authRemoteDataSource.login(email: email, password: password);
      return right(user);
    } on AuthException catch (e) {
      return left(Failure.authFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _authRemoteDataSource.logout();
      return right(unit);
    } on AuthException catch (e) {
      return left(Failure.authFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> register(
      {required String email, required String password}) async {
    try {
      final user = await _authRemoteDataSource.register(
          email: email, password: password);
      return right(user);
    } on AuthException catch (e) {
      return left(Failure.authFailure(message: e.message));
    }
  }
}
