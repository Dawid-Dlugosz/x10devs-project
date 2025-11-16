import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:x10devs/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}

class MockUser extends Mock implements User {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('AuthRepositoryImpl', () {
    group('register', () {
      const testEmail = 'test@example.com';
      const testPassword = 'Test123!@#';

      test(
        'should return Right(User) when registration is successful',
        () async {
          final mockUser = MockUser();

          when(
            () => mockDataSource.register(
              email: testEmail,
              password: testPassword,
            ),
          ).thenAnswer((_) async => mockUser);

          final result = await repository.register(
            email: testEmail,
            password: testPassword,
          );

          expect(result, isA<Right<Failure, User>>());
          result.fold(
            (failure) => fail('Should not return failure'),
            (user) => expect(user, equals(mockUser)),
          );
          verify(
            () => mockDataSource.register(
              email: testEmail,
              password: testPassword,
            ),
          ).called(1);
        },
      );

      test(
        'should return Left(AuthFailure) when AuthException is thrown',
        () async {
          const errorMessage = 'Email already in use';

          when(
            () => mockDataSource.register(
              email: testEmail,
              password: testPassword,
            ),
          ).thenThrow(const AuthException(errorMessage));

          final result = await repository.register(
            email: testEmail,
            password: testPassword,
          );

          expect(result, isA<Left<Failure, User>>());
          result.fold((failure) {
            expect(failure, isA<Failure>());
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => expect(message, equals(errorMessage)),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (user) => fail('Should not return user'));
        },
      );
    });

    group('login', () {
      const testEmail = 'test@example.com';
      const testPassword = 'Test123!@#';

      test('should return Right(User) when login is successful', () async {
        final mockUser = MockUser();

        when(
          () => mockDataSource.login(email: testEmail, password: testPassword),
        ).thenAnswer((_) async => mockUser);

        final result = await repository.login(
          email: testEmail,
          password: testPassword,
        );

        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (user) => expect(user, equals(mockUser)),
        );
      });

      test(
        'should return Left(AuthFailure) when AuthException is thrown',
        () async {
          const errorMessage = 'Invalid credentials';

          when(
            () =>
                mockDataSource.login(email: testEmail, password: testPassword),
          ).thenThrow(const AuthException(errorMessage));

          final result = await repository.login(
            email: testEmail,
            password: testPassword,
          );

          expect(result, isA<Left<Failure, User>>());
          result.fold((failure) {
            expect(failure, isA<Failure>());
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => expect(message, equals(errorMessage)),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (user) => fail('Should not return user'));
        },
      );

      test(
        'should return Left(ServerFailure) when generic Exception is thrown',
        () async {
          const errorMessage = 'Network error';

          when(
            () =>
                mockDataSource.login(email: testEmail, password: testPassword),
          ).thenThrow(Exception(errorMessage));

          final result = await repository.login(
            email: testEmail,
            password: testPassword,
          );

          expect(result, isA<Left<Failure, User>>());
          result.fold((failure) {
            expect(failure, isA<Failure>());
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) =>
                  expect(message, contains(errorMessage)),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (user) => fail('Should not return user'));
        },
      );
    });

    group('logout', () {
      test('should return Right(Unit) when logout is successful', () async {
        when(() => mockDataSource.logout()).thenAnswer((_) async => {});

        final result = await repository.logout();

        expect(result, isA<Right<Failure, Unit>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (unit) => expect(unit, equals(unit)),
        );
        verify(() => mockDataSource.logout()).called(1);
      });

      test(
        'should return Left(AuthFailure) when AuthException is thrown',
        () async {
          const errorMessage = 'Logout failed';

          when(
            () => mockDataSource.logout(),
          ).thenThrow(const AuthException(errorMessage));

          final result = await repository.logout();

          expect(result, isA<Left<Failure, Unit>>());
          result.fold((failure) {
            expect(failure, isA<Failure>());
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => expect(message, equals(errorMessage)),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (unit) => fail('Should not return unit'));
        },
      );
    });

    group('getCurrentUser', () {
      test('should return Right(User) when user is authenticated', () async {
        final mockUser = MockUser();

        when(
          () => mockDataSource.getCurrentUser(),
        ).thenAnswer((_) async => mockUser);

        final result = await repository.getCurrentUser();

        expect(result, isA<Right<Failure, User?>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (user) => expect(user, equals(mockUser)),
        );
      });

      test(
        'should return Right(null) when user is not authenticated',
        () async {
          when(
            () => mockDataSource.getCurrentUser(),
          ).thenAnswer((_) async => null);

          final result = await repository.getCurrentUser();

          expect(result, isA<Right<Failure, User?>>());
          result.fold(
            (failure) => fail('Should not return failure'),
            (user) => expect(user, isNull),
          );
        },
      );

      test(
        'should return Left(AuthFailure) when AuthException is thrown',
        () async {
          const errorMessage = 'Session expired';

          when(
            () => mockDataSource.getCurrentUser(),
          ).thenThrow(const AuthException(errorMessage));

          final result = await repository.getCurrentUser();

          expect(result, isA<Left<Failure, User?>>());
          result.fold((failure) {
            expect(failure, isA<Failure>());
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => expect(message, equals(errorMessage)),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (user) => fail('Should not return user'));
        },
      );
    });

    group('Edge Cases', () {
      group('TC-REPO-AUTH-001: Login with malformed email address', () {
        test('should handle malformed email', () async {
          const malformedEmail = 'not-an-email';
          const testPassword = 'Test123!@#';

          when(
            () => mockDataSource.login(
              email: malformedEmail,
              password: testPassword,
            ),
          ).thenThrow(const AuthException('Invalid email format'));

          final result = await repository.login(
            email: malformedEmail,
            password: testPassword,
          );

          expect(result, isA<Left<Failure, User>>());
        });
      });

      group(
        'TC-REPO-AUTH-002: Register with password containing only whitespace',
        () {
          test('should handle whitespace-only password', () async {
            const testEmail = 'test@example.com';
            const whitespacePassword = '        ';

            when(
              () => mockDataSource.register(
                email: testEmail,
                password: whitespacePassword,
              ),
            ).thenThrow(const AuthException('Invalid password'));

            final result = await repository.register(
              email: testEmail,
              password: whitespacePassword,
            );

            expect(result, isA<Left<Failure, User>>());
          });
        },
      );

      group('TC-REPO-AUTH-005: Handle unexpected exceptions', () {
        test('should map generic Exception to ServerFailure', () async {
          const testEmail = 'test@example.com';
          const testPassword = 'Test123!@#';

          when(
            () =>
                mockDataSource.login(email: testEmail, password: testPassword),
          ).thenThrow(Exception('Unexpected error'));

          final result = await repository.login(
            email: testEmail,
            password: testPassword,
          );

          expect(result, isA<Left<Failure, User>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) =>
                  expect(message, contains('Unexpected error')),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (user) => fail('Should not return user'));
        });
      });
    });
  });
}
