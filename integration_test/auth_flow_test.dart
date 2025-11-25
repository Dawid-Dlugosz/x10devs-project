import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_main.dart' as app;

import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow E2E Tests', () {
    late String testEmail;

    setUp(() async {
      // Each test gets a fresh email
      testEmail = TestHelpers.generateTestEmail();
    });

    tearDown(() async {
      // Cleanup test data after each test
      try {
        await TestHelpers.cleanupTestUser(testEmail);
      } catch (e) {
        // Ignore cleanup errors
        debugPrint('Cleanup error (non-critical): $e');
      }

      // Give some time for cleanup to complete
      await Future.delayed(const Duration(milliseconds: 500));
    });

    testWidgets('TC-E2E-AUTH-001: User can register with valid credentials', (
      tester,
    ) async {
      // Arrange - Start app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await TestHelpers.ensureLoggedOut(tester);

      // Act
      final email = await TestHelpers.registerTestUser(tester);

      // Wait for navigation and decks page to load
      await TestHelpers.waitForDecksPageToLoad(tester);

      // Assert
      await TestHelpers.verifyLoggedIn(tester);

      testEmail = email; // Save for cleanup
    });

    testWidgets('TC-E2E-AUTH-004: User cannot login with invalid password', (
      tester,
    ) async {
      // Arrange - Start app and register user first
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      testEmail = await TestHelpers.registerTestUser(tester);

      // Logout
      await TestHelpers.logoutUser(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Wait for auth state to settle
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Act - Try to login with wrong password
      final loginLink = find.text('Masz już konto? Zaloguj się');
      if (loginLink.evaluate().isNotEmpty) {
        await tester.tap(loginLink);
        await tester.pumpAndSettle();
      }

      final emailFields = find.byType(EditableText);
      if (emailFields.evaluate().isNotEmpty) {
        await tester.enterText(emailFields.at(0), testEmail);
        await tester.pumpAndSettle();

        final passwordFields = find.byType(EditableText);
        await tester.enterText(passwordFields.at(1), 'WrongPassword123!');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Zaloguj'));
        await tester.pump(); // Start the login process
        await tester.pump(const Duration(seconds: 1)); // Wait for error

        // Assert - Should show error toast (check immediately before it disappears)
        expect(
          find.text('Błąd logowania'),
          findsOneWidget,
          reason: 'Should show "login error" toast',
        );

        await tester.pumpAndSettle(); // Let toast disappear
      }
    });

    testWidgets('TC-E2E-AUTH-007: Validation - Empty email shows error', (
      tester,
    ) async {
      // Arrange - Start app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to login
      final loginLink = find.text('Masz już konto? Zaloguj się');
      if (loginLink.evaluate().isNotEmpty) {
        await tester.tap(loginLink);
        await tester.pumpAndSettle();
      }

      // Act - Try to submit with empty email
      await tester.tap(find.text('Zaloguj'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Pole e-mail jest wymagane'),
        findsOneWidget,
        reason: 'Should show required email error',
      );
    });

    testWidgets('TC-E2E-AUTH-008: Validation - Invalid email format', (
      tester,
    ) async {
      // Arrange - Start app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final loginLink = find.text('Masz już konto? Zaloguj się');
      if (loginLink.evaluate().isNotEmpty) {
        await tester.tap(loginLink);
        await tester.pumpAndSettle();
      }

      // Act - Enter invalid email
      final emailFields = find.byType(EditableText);
      await tester.enterText(emailFields.first, 'invalid-email');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zaloguj'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Wprowadź poprawny adres e-mail'),
        findsOneWidget,
        reason: 'Should show invalid email format error',
      );
    });

    testWidgets('TC-E2E-AUTH-009: Validation - Password too short', (
      tester,
    ) async {
      // Arrange - Start app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final registerLink = find.text('Nie masz konta? Zarejestruj się');
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      await TestHelpers.waitForText(tester, 'Stwórz konto');

      // Act - Enter short password
      final emailFields = find.byType(EditableText);
      await tester.enterText(emailFields.at(0), testEmail);
      await tester.pumpAndSettle();

      final passwordFields = find.byType(EditableText);
      await tester.enterText(passwordFields.at(1), 'short');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zarejestruj się'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Hasło musi mieć co najmniej 8 znaków'),
        findsOneWidget,
        reason: 'Should show password too short error',
      );
    });

    testWidgets('TC-E2E-AUTH-010: Validation - Passwords do not match', (
      tester,
    ) async {
      // Arrange - Start app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final registerLink = find.text('Nie masz konta? Zarejestruj się');
      if (registerLink.evaluate().isNotEmpty) {
        await tester.tap(registerLink);
        await tester.pumpAndSettle();
      }

      await TestHelpers.waitForText(tester, 'Stwórz konto');

      // Act - Enter mismatched passwords
      final emailFields = find.byType(EditableText);
      await tester.enterText(emailFields.at(0), testEmail);
      await tester.pumpAndSettle();

      final passwordFields = find.byType(EditableText);
      await tester.enterText(passwordFields.at(1), 'Password123!');
      await tester.pumpAndSettle();

      final confirmPasswordField = find.byType(EditableText);
      await tester.enterText(
        confirmPasswordField.at(2),
        'DifferentPassword123!',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zarejestruj się'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Hasła nie są zgodne'),
        findsOneWidget,
        reason: 'Should show passwords mismatch error',
      );
    });
  });
}
