import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:x10devs/features/auth/domain/repositories/auth_repository.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState.initial());

  final IAuthRepository _authRepository;

  Future<void> checkAuthStatus() async {
    emit(const AuthState.loading());
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(AuthState.error(failure: failure)),
      (user) {
        if (user != null) {
          emit(AuthState.authenticated(user: user));
        } else {
          emit(const AuthState.unauthenticated());
        }
      },
    );
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    final result = await _authRepository.login(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure: failure)),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> register(String email, String password) async {
    emit(const AuthState.loading());
    final result = await _authRepository.register(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure: failure)),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    final result = await _authRepository.logout();
    result.fold(
      (failure) => emit(AuthState.error(failure: failure)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }
}
