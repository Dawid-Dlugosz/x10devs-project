import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/auth/domain/repositories/auth_repository.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_state.dart'
    as app_auth;

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late AuthCubit cubit;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    cubit = AuthCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthCubit', () {
    group('initial state', () {
      test('should have initial state', () {
        expect(cubit.state, equals(const app_auth.AuthState.initial()));
      });
    });

    group('checkAuthStatus', () {
      test(
        'should emit [loading, authenticated] when user is logged in',
        () async {
          final mockUser = MockUser();

          when(
            () => mockRepository.getCurrentUser(),
          ).thenAnswer((_) async => Right(mockUser));

          final expected = [
            const app_auth.AuthState.loading(),
            app_auth.AuthState.authenticated(user: mockUser),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.checkAuthStatus();
        },
      );

      test(
        'should emit [loading, unauthenticated] when user is not logged in',
        () async {
          when(
            () => mockRepository.getCurrentUser(),
          ).thenAnswer((_) async => const Right(null));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.unauthenticated(),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.checkAuthStatus();
        },
      );

      test('should emit [loading, error] when getCurrentUser fails', () async {
        const failure = Failure.authFailure(message: 'Session expired');

        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Left(failure));

        final expected = [
          const app_auth.AuthState.loading(),
          const app_auth.AuthState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.checkAuthStatus();
      });
    });

    group('login', () {
      const testEmail = 'test@example.com';
      const testPassword = 'Test123!@#';

      test(
        'should emit [loading, authenticated] when login succeeds',
        () async {
          final mockUser = MockUser();

          when(
            () =>
                mockRepository.login(email: testEmail, password: testPassword),
          ).thenAnswer((_) async => Right(mockUser));

          final expected = [
            const app_auth.AuthState.loading(),
            app_auth.AuthState.authenticated(user: mockUser),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.login(testEmail, testPassword);
        },
      );

      test(
        'should emit [loading, error] when login fails with AuthFailure',
        () async {
          const failure = Failure.authFailure(message: 'Invalid credentials');

          when(
            () =>
                mockRepository.login(email: testEmail, password: testPassword),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.login(testEmail, testPassword);
        },
      );

      test('should call repository.login with correct parameters', () async {
        final mockUser = MockUser();

        when(
          () => mockRepository.login(email: testEmail, password: testPassword),
        ).thenAnswer((_) async => Right(mockUser));

        await cubit.login(testEmail, testPassword);

        verify(
          () => mockRepository.login(email: testEmail, password: testPassword),
        ).called(1);
      });
    });

    group('register', () {
      const testEmail = 'test@example.com';
      const testPassword = 'Test123!@#';

      test(
        'should emit [loading, authenticated] when registration succeeds',
        () async {
          final mockUser = MockUser();

          when(
            () => mockRepository.register(
              email: testEmail,
              password: testPassword,
            ),
          ).thenAnswer((_) async => Right(mockUser));

          final expected = [
            const app_auth.AuthState.loading(),
            app_auth.AuthState.authenticated(user: mockUser),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.register(testEmail, testPassword);
        },
      );

      test(
        'should emit [loading, error] when registration fails with AuthFailure',
        () async {
          const failure = Failure.authFailure(message: 'Email already in use');

          when(
            () => mockRepository.register(
              email: testEmail,
              password: testPassword,
            ),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.register(testEmail, testPassword);
        },
      );

      test('should call repository.register with correct parameters', () async {
        final mockUser = MockUser();

        when(
          () =>
              mockRepository.register(email: testEmail, password: testPassword),
        ).thenAnswer((_) async => Right(mockUser));

        await cubit.register(testEmail, testPassword);

        verify(
          () =>
              mockRepository.register(email: testEmail, password: testPassword),
        ).called(1);
      });
    });

    group('logout', () {
      test(
        'should emit [loading, unauthenticated] when logout succeeds',
        () async {
          when(
            () => mockRepository.logout(),
          ).thenAnswer((_) async => Right(unit));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.unauthenticated(),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.logout();
        },
      );

      test('should emit [loading, error] when logout fails', () async {
        const failure = Failure.authFailure(message: 'Logout failed');

        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Left(failure));

        final expected = [
          const app_auth.AuthState.loading(),
          const app_auth.AuthState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.logout();
      });

      test('should call repository.logout', () async {
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => Right(unit));

        await cubit.logout();

        verify(() => mockRepository.logout()).called(1);
      });
    });

    group('Edge Cases', () {
      group('TC-AUTH-EDGE-001: Login with empty email', () {
        test('should handle empty email', () async {
          const emptyEmail = '';
          const testPassword = 'Test123!@#';
          const failure = Failure.authFailure(message: 'Invalid email');

          when(
            () =>
                mockRepository.login(email: emptyEmail, password: testPassword),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.login(emptyEmail, testPassword);
        });
      });

      group('TC-AUTH-EDGE-002: Login with empty password', () {
        test('should handle empty password', () async {
          const testEmail = 'test@example.com';
          const emptyPassword = '';
          const failure = Failure.authFailure(message: 'Invalid password');

          when(
            () =>
                mockRepository.login(email: testEmail, password: emptyPassword),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.login(testEmail, emptyPassword);
        });
      });

      group('TC-AUTH-EDGE-003: Login with email containing only spaces', () {
        test('should handle whitespace-only email', () async {
          const whitespaceEmail = '     ';
          const testPassword = 'Test123!@#';
          const failure = Failure.authFailure(message: 'Invalid email');

          when(
            () => mockRepository.login(
              email: whitespaceEmail,
              password: testPassword,
            ),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.login(whitespaceEmail, testPassword);
        });
      });

      group('TC-AUTH-EDGE-004: Login with invalid email format', () {
        test('should handle invalid email format', () async {
          const invalidEmail = 'not-an-email';
          const testPassword = 'Test123!@#';
          const failure = Failure.authFailure(message: 'Invalid email format');

          when(
            () => mockRepository.login(
              email: invalidEmail,
              password: testPassword,
            ),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.login(invalidEmail, testPassword);
        });
      });

      group('TC-AUTH-EDGE-005: Register with short password', () {
        test('should handle password shorter than minimum', () async {
          const testEmail = 'test@example.com';
          const shortPassword = '123';
          const failure = Failure.authFailure(message: 'Password too short');

          when(
            () => mockRepository.register(
              email: testEmail,
              password: shortPassword,
            ),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.register(testEmail, shortPassword);
        });
      });

      group('TC-AUTH-EDGE-008: checkAuthStatus when token expired', () {
        test('should handle expired token', () async {
          const failure = Failure.sessionExpiredFailure(
            message: 'Token expired',
          );

          when(
            () => mockRepository.getCurrentUser(),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.checkAuthStatus();
        });
      });

      group('TC-AUTH-EDGE-010: Logout when already logged out', () {
        test('should handle logout when already logged out', () async {
          const failure = Failure.authFailure(
            message: 'User already logged out',
          );

          when(
            () => mockRepository.logout(),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const app_auth.AuthState.loading(),
            const app_auth.AuthState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.logout();
        });
      });
    });
  });
}
