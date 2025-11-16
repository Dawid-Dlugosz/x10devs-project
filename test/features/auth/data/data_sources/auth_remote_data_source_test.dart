import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/features/auth/data/data_sources/auth_remote_data_source.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockUser extends Mock implements User {}

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    dataSource = AuthRemoteDataSourceImpl(mockSupabaseClient);

    when(() => mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
  });

  group('AuthRemoteDataSource', () {
    group('register', () {
      const testEmail = 'test@example.com';
      const testPassword = 'Test123!@#';

      test('should return User when registration is successful', () async {
        final mockUser = MockUser();
        final mockResponse = MockAuthResponse();

        when(() => mockResponse.user).thenReturn(mockUser);
        when(
          () =>
              mockGoTrueClient.signUp(email: testEmail, password: testPassword),
        ).thenAnswer((_) async => mockResponse);

        final result = await dataSource.register(
          email: testEmail,
          password: testPassword,
        );

        expect(result, equals(mockUser));
        verify(
          () =>
              mockGoTrueClient.signUp(email: testEmail, password: testPassword),
        ).called(1);
      });

      test('should throw AuthException when user is null', () async {
        final mockResponse = MockAuthResponse();

        when(() => mockResponse.user).thenReturn(null);
        when(
          () =>
              mockGoTrueClient.signUp(email: testEmail, password: testPassword),
        ).thenAnswer((_) async => mockResponse);

        expect(
          () => dataSource.register(email: testEmail, password: testPassword),
          throwsA(isA<AuthException>()),
        );
      });

      test('should throw AuthException when Supabase throws error', () async {
        when(
          () =>
              mockGoTrueClient.signUp(email: testEmail, password: testPassword),
        ).thenThrow(const AuthException('Email already in use'));

        expect(
          () => dataSource.register(email: testEmail, password: testPassword),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('login', () {
      const testEmail = 'test@example.com';
      const testPassword = 'Test123!@#';

      test('should return User when login is successful', () async {
        final mockUser = MockUser();
        final mockResponse = MockAuthResponse();

        when(() => mockResponse.user).thenReturn(mockUser);
        when(
          () => mockGoTrueClient.signInWithPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await dataSource.login(
          email: testEmail,
          password: testPassword,
        );

        expect(result, equals(mockUser));
        verify(
          () => mockGoTrueClient.signInWithPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).called(1);
      });

      test('should throw AuthException when credentials are invalid', () async {
        final mockResponse = MockAuthResponse();

        when(() => mockResponse.user).thenReturn(null);
        when(
          () => mockGoTrueClient.signInWithPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => mockResponse);

        expect(
          () => dataSource.login(email: testEmail, password: testPassword),
          throwsA(isA<AuthException>()),
        );
      });

      test('should throw AuthException when Supabase throws error', () async {
        when(
          () => mockGoTrueClient.signInWithPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenThrow(const AuthException('Invalid credentials'));

        expect(
          () => dataSource.login(email: testEmail, password: testPassword),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('logout', () {
      test('should call signOut successfully', () async {
        when(
          () => mockGoTrueClient.signOut(),
        ).thenAnswer((_) async => Future.value());

        await dataSource.logout();

        verify(() => mockGoTrueClient.signOut()).called(1);
      });

      test('should throw AuthException when logout fails', () async {
        when(
          () => mockGoTrueClient.signOut(),
        ).thenThrow(const AuthException('Logout failed'));

        expect(() => dataSource.logout(), throwsA(isA<AuthException>()));
      });
    });

    group('getCurrentUser', () {
      test('should return User when user is authenticated', () async {
        final mockUser = MockUser();

        when(() => mockGoTrueClient.currentUser).thenReturn(mockUser);

        final result = await dataSource.getCurrentUser();

        expect(result, equals(mockUser));
      });

      test('should return null when user is not authenticated', () async {
        when(() => mockGoTrueClient.currentUser).thenReturn(null);

        final result = await dataSource.getCurrentUser();

        expect(result, isNull);
      });
    });

    group('Edge Cases', () {
      group('TC-DS-AUTH-001: getCurrentUser when Supabase client is null', () {
        test('should handle null client gracefully', () async {
          when(() => mockGoTrueClient.currentUser).thenReturn(null);

          final result = await dataSource.getCurrentUser();

          expect(result, isNull);
        });
      });

      group(
        'TC-DS-AUTH-002: Login with credentials containing special characters',
        () {
          test(
            'should handle special characters in email and password',
            () async {
              const specialEmail = 'test+special@example.com';
              const specialPassword = 'P@ssw0rd!#\$%^&*()';
              final mockUser = MockUser();
              final mockResponse = MockAuthResponse();

              when(() => mockResponse.user).thenReturn(mockUser);
              when(
                () => mockGoTrueClient.signInWithPassword(
                  email: specialEmail,
                  password: specialPassword,
                ),
              ).thenAnswer((_) async => mockResponse);

              final result = await dataSource.login(
                email: specialEmail,
                password: specialPassword,
              );

              expect(result, equals(mockUser));
            },
          );
        },
      );

      group('TC-DS-AUTH-003: Logout when session already expired', () {
        test('should handle expired session during logout', () async {
          when(
            () => mockGoTrueClient.signOut(),
          ).thenThrow(const AuthException('Session expired'));

          expect(() => dataSource.logout(), throwsA(isA<AuthException>()));
        });
      });

      group('TC-DS-AUTH-004: Register with email in different formats', () {
        test('should handle uppercase email', () async {
          const uppercaseEmail = 'TEST@EXAMPLE.COM';
          const testPassword = 'Test123!@#';
          final mockUser = MockUser();
          final mockResponse = MockAuthResponse();

          when(() => mockResponse.user).thenReturn(mockUser);
          when(
            () => mockGoTrueClient.signUp(
              email: uppercaseEmail,
              password: testPassword,
            ),
          ).thenAnswer((_) async => mockResponse);

          final result = await dataSource.register(
            email: uppercaseEmail,
            password: testPassword,
          );

          expect(result, equals(mockUser));
        });

        test('should handle mixed case email', () async {
          const mixedEmail = 'TeSt@ExAmPlE.CoM';
          const testPassword = 'Test123!@#';
          final mockUser = MockUser();
          final mockResponse = MockAuthResponse();

          when(() => mockResponse.user).thenReturn(mockUser);
          when(
            () => mockGoTrueClient.signUp(
              email: mixedEmail,
              password: testPassword,
            ),
          ).thenAnswer((_) async => mockResponse);

          final result = await dataSource.register(
            email: mixedEmail,
            password: testPassword,
          );

          expect(result, equals(mockUser));
        });
      });
    });
  });
}
