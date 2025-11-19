import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Helper class for E2E test setup and teardown
class TestHelpers {
  static SupabaseClient get supabase => Supabase.instance.client;

  /// Generates a unique test email using timestamp
  static String generateTestEmail() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'test.user.$timestamp@example.com';
  }

  /// Generates a test password
  static const String testPassword = 'TestPassword123!';

  /// Registers a new test user and returns the email
  static Future<String> registerTestUser(WidgetTester tester) async {
    final email = generateTestEmail();

    // Navigate to register page if not already there
    final registerLink = find.text('Nie masz konta? Zarejestruj się');
    if (registerLink.evaluate().isNotEmpty) {
      await tester.tap(registerLink);
      await tester.pumpAndSettle();
    }

    // Wait for register form to appear
    await waitForText(tester, 'Stwórz konto');

    // Fill in registration form - find EditableText widgets by order
    final editableTexts = find.byType(EditableText);

    // First field is email
    await tester.enterText(editableTexts.at(0), email);
    await tester.pumpAndSettle();

    // Second field is password
    await tester.enterText(editableTexts.at(1), testPassword);
    await tester.pumpAndSettle();

    // Third field is confirm password
    await tester.enterText(editableTexts.at(2), testPassword);
    await tester.pumpAndSettle();

    // Submit registration
    final registerButton = find.text('Zarejestruj się');
    expect(
      registerButton,
      findsWidgets,
      reason: 'Register button should exist',
    );
    await tester.tap(
      registerButton.last,
    ); // Use .last to get the button, not the link
    await tester.pumpAndSettle();

    await tester.pumpAndSettle(const Duration(seconds: 5));

    return email;
  }

  /// Logs in with given credentials
  static Future<void> loginUser(
    WidgetTester tester, {
    required String email,
    required String password,
  }) async {
    // Navigate to login page if not already there
    final loginLink = find.text('Masz już konto? Zaloguj się');
    if (loginLink.evaluate().isNotEmpty) {
      await tester.tap(loginLink);
      await tester.pumpAndSettle();
    }

    // Fill in login form - find EditableText widgets by order
    final editableTexts = find.byType(EditableText);

    // First field is email
    await tester.enterText(editableTexts.at(0), email);
    await tester.pumpAndSettle();

    // Second field is password
    await tester.enterText(editableTexts.at(1), password);
    await tester.pumpAndSettle();

    // Submit login
    await tester.tap(find.text('Zaloguj'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  /// Logs out the current user
  static Future<void> logoutUser(WidgetTester tester) async {
    // Find and tap logout button/icon
    // Note: Adjust this based on your actual logout UI implementation
    final logoutIcon = find.byIcon(Icons.logout);
    if (logoutIcon.evaluate().isNotEmpty) {
      await tester.tap(logoutIcon);
      await tester.pumpAndSettle();
      // Give router time to redirect
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      return;
    }

    // Alternative: look for logout text button
    final logoutButton = find.text('Wyloguj');
    if (logoutButton.evaluate().isNotEmpty) {
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      // Give router time to redirect
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      return;
    }

    // Alternative: look for menu button first
    final menuButton = find.byIcon(Icons.menu);
    if (menuButton.evaluate().isNotEmpty) {
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Then find logout in menu
      final logoutInMenu = find.text('Wyloguj');
      if (logoutInMenu.evaluate().isNotEmpty) {
        await tester.tap(logoutInMenu);
        await tester.pumpAndSettle();
        // Give router time to redirect
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
      }
    }
  }

  /// Cleans up test user and all associated data
  static Future<void> cleanupTestUser(String email) async {
    try {
      // Sign in as the test user to get their ID
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: testPassword,
      );

      if (response.user != null) {
        final userId = response.user!.id;

        // First, get all deck IDs for this user
        final decksResponse = await supabase
            .from('decks')
            .select('id')
            .eq('user_id', userId);

        if (decksResponse.isNotEmpty) {
          final deckIds = decksResponse
              .map((deck) => deck['id'] as int)
              .toList();

          // Delete all flashcards for these decks
          if (deckIds.isNotEmpty) {
            await supabase
                .from('flashcards')
                .delete()
                .inFilter('deck_id', deckIds);
          }
        }

        // Delete all decks for this user
        await supabase.from('decks').delete().eq('user_id', userId);

        // Sign out
        await supabase.auth.signOut();

        // Note: We cannot delete auth users via client SDK
        // They will be cleaned up manually or via admin API if needed
      }
    } catch (e) {
      // Ignore cleanup errors in tests
      debugPrint('Cleanup error (non-critical): $e');
    }
  }

  /// Waits for a specific text to appear (with timeout)
  static Future<void> waitForText(
    WidgetTester tester,
    String text, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      // Use pump instead of pumpAndSettle to avoid conflicts
      await tester.pump(const Duration(milliseconds: 100));

      if (find.text(text).evaluate().isNotEmpty) {
        // One final pumpAndSettle to ensure UI is stable
        await tester.pumpAndSettle();
        return;
      }

      await Future.delayed(const Duration(milliseconds: 100));
    }

    throw Exception('Timeout waiting for text: $text');
  }

  /// Waits for a specific widget to appear (with timeout)
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      // Use pump instead of pumpAndSettle to avoid conflicts
      await tester.pump(const Duration(milliseconds: 100));

      if (finder.evaluate().isNotEmpty) {
        // One final pumpAndSettle to ensure UI is stable
        await tester.pumpAndSettle();
        return;
      }

      await Future.delayed(const Duration(milliseconds: 100));
    }

    throw Exception('Timeout waiting for widget: $finder');
  }

  /// Resets the database to a clean state
  /// Note: This only works if RLS policies allow it or if using service role key
  static Future<void> resetDatabase() async {
    try {
      // Delete all test data
      // Warning: This will delete ALL data, not just test data
      // Use with caution and only in test environment
      await supabase.from('flashcards').delete().gte('id', 0);
      await supabase.from('decks').delete().gte('id', 0);
    } catch (e) {
      // Ignore errors - RLS policies might prevent this
      debugPrint('Database reset error (non-critical): $e');
    }
  }

  /// Verifies that user is logged in
  static void verifyLoggedIn(WidgetTester tester) {
    expect(
      find.text('Twoje Talie'),
      findsOneWidget,
      reason: 'Should be on decks page after login',
    );
  }

  /// Verifies that user is logged out
  static void verifyLoggedOut(WidgetTester tester) {
    expect(
      find.text('Zaloguj się'),
      findsOneWidget,
      reason: 'Should be on login page after logout',
    );
  }

  /// Ensures the app is in a clean state (logged out, on login page)
  static Future<void> ensureLoggedOut(WidgetTester tester) async {
    // Check if we're already on login/register page
    final loginButton = find.text('Zaloguj');
    final registerButton = find.text('Zarejestruj się');

    if (loginButton.evaluate().isNotEmpty ||
        registerButton.evaluate().isNotEmpty) {
      debugPrint('✅ Already on auth page');
      return;
    }

    // We're logged in, need to logout
    debugPrint('🔄 Logging out to reset state...');
    try {
      await logoutUser(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('⚠️ Logout failed (might already be logged out): $e');
    }
  }
}
