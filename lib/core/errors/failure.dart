import 'dart:ffi';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.failure({required String message}) = _Failure;
  const factory Failure.serverFailure({required String message}) = _ServerFailure;
  const factory Failure.authFailure({required String message}) = _AuthFailure;
  const factory Failure.invalidCredentialsFailure({required String message}) = _InvalidCredentialsFailure;
  const factory Failure.emailInUseFailure({required String message}) = _EmailInUseFailure;
  const factory Failure.sessionExpiredFailure({required String message}) = _SessionExpiredFailure;
  const factory Failure.aigenerationFailure({required String message}) = _AIGenerationFailure;
}
