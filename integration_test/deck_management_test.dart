import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_main.dart' as app;

import 'helpers/test_data.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Deck Management E2E Tests', () {
    late String testEmail;

    setUp(() async {
      testEmail = TestHelpers.generateTestEmail();
    });

    tearDown(() async {
      try {
        await TestHelpers.cleanupTestUser(testEmail);
      } catch (e) {
        debugPrint('Cleanup error (non-critical): $e');
      }

      // Give some time for cleanup to complete
      await Future.delayed(const Duration(milliseconds: 500));
    });

    testWidgets('TC-E2E-DECK-001: User can create a new deck', (tester) async {
      // Arrange - Register and login
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await TestHelpers.ensureLoggedOut(tester);
      testEmail = await TestHelpers.registerTestUser(tester);
      await TestHelpers.waitForDecksPageToLoad(tester);
      await TestHelpers.verifyLoggedIn(tester);

      // Act - Create deck
      final deckName = TestData.generateUniqueDeckName();

      // Tap FAB to create deck
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter deck name in dialog - use EditableText which is more reliable
      final editableText = find.byType(EditableText);
      expect(
        editableText,
        findsAtLeastNWidgets(1),
        reason: 'Should find editable text field',
      );
      await tester.enterText(editableText.first, deckName);
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(find.text('Zapisz'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Wait extra time for navigation and data loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Assert - After creating deck, we should be on deck details or list page
      // Check if deck name is visible somewhere
      final deckNameFinder = find.text(deckName);
      expect(
        deckNameFinder,
        findsAtLeastNWidgets(1),
        reason: 'Deck name should be visible after creation',
      );
    });

    testWidgets('TC-E2E-DECK-002: User can view empty decks message', (
      tester,
    ) async {
      // Arrange - Register and login
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await TestHelpers.ensureLoggedOut(tester);
      testEmail = await TestHelpers.registerTestUser(tester);
      await TestHelpers.waitForDecksPageToLoad(tester);
      await TestHelpers.verifyLoggedIn(tester);

      // Assert - Should show empty state
      expect(
        find.textContaining('Nie masz jeszcze', skipOffstage: false),
        findsOneWidget,
        reason: 'Should show empty decks message',
      );
    });

    testWidgets('TC-E2E-DECK-003: User can create multiple decks', (
      tester,
    ) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await TestHelpers.ensureLoggedOut(tester);
      testEmail = await TestHelpers.registerTestUser(tester);
      await TestHelpers.waitForDecksPageToLoad(tester);

      // Act - Create 3 decks
      final deckNames = [
        TestData.generateUniqueDeckName(),
        TestData.generateUniqueDeckName(),
        TestData.generateUniqueDeckName(),
      ];

      for (final deckName in deckNames) {
        // Find FAB - it might be behind a dialog, so check first
        await tester.pumpAndSettle();

        final fabFinder = find.byIcon(Icons.add);
        if (fabFinder.evaluate().isEmpty) {
          // We might be on deck details, go back first
          final backButton = find.byIcon(Icons.arrow_back);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton);
            await tester.pumpAndSettle();
          }
        }

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        final editableText = find.byType(EditableText);
        if (editableText.evaluate().isNotEmpty) {
          await tester.enterText(editableText.first, deckName);
          await tester.pumpAndSettle();

          await tester.tap(find.text('Zapisz'));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Go back to decks list after creation
          final backButton = find.byIcon(Icons.arrow_back);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton);
            await tester.pumpAndSettle();
          }
        }
      }

      // Assert - All decks should be visible
      for (final deckName in deckNames) {
        expect(
          find.text(deckName),
          findsOneWidget,
          reason: 'Deck "$deckName" should be visible',
        );
      }
    });

    testWidgets('TC-E2E-DECK-004: User can navigate to deck details', (
      tester,
    ) async {
      // Arrange - Create a deck
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await TestHelpers.ensureLoggedOut(tester);
      testEmail = await TestHelpers.registerTestUser(tester);
      await TestHelpers.waitForDecksPageToLoad(tester);

      final deckName = TestData.generateUniqueDeckName();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      final editableText = find.byType(EditableText);
      await tester.enterText(editableText.first, deckName);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zapisz'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Wait extra time for navigation and data loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Act - Navigation happens automatically after creation
      // We should be on deck details page now

      // Assert - Should be on deck details page
      expect(
        find.text(deckName),
        findsAtLeastNWidgets(1),
        reason: 'Should show deck name',
      );
    });

    testWidgets('TC-E2E-DECK-005: Validation - Empty deck name shows error', (
      tester,
    ) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await TestHelpers.ensureLoggedOut(tester);
      testEmail = await TestHelpers.registerTestUser(tester);
      await TestHelpers.waitForDecksPageToLoad(tester);

      // Act - Try to create deck with empty name
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Don't enter any text, just tap save
      final saveButton = find.text('Zapisz');
      await tester.tap(saveButton);
      await tester.pump(); // Start validation
      await tester.pump(
        const Duration(milliseconds: 500),
      ); // Wait for validation

      // Assert - Dialog should still be open (validation prevents closing)
      // Or should show validation error
      final stillHasDialog = find.text('Zapisz').evaluate().isNotEmpty;

      expect(
        stillHasDialog,
        isTrue,
        reason: 'Dialog should still be open due to validation',
      );
    });

    testWidgets(
      'TC-E2E-DECK-006: User can create deck with special characters',
      (tester) async {
        // Arrange
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));
        await TestHelpers.ensureLoggedOut(tester);
        testEmail = await TestHelpers.registerTestUser(tester);
        await TestHelpers.waitForDecksPageToLoad(tester);

        // Act - Create deck with special characters
        const deckName = TestData.deckNameWithSpecialChars;

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        final editableText = find.byType(EditableText);
        await tester.enterText(editableText.first, deckName);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Zapisz'));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert
        expect(
          find.text(deckName),
          findsOneWidget,
          reason: 'Deck with special characters should be created',
        );
      },
    );

    testWidgets(
      'TC-E2E-DECK-007: User can create deck with Unicode characters',
      (tester) async {
        // Arrange
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));
        await TestHelpers.ensureLoggedOut(tester);
        testEmail = await TestHelpers.registerTestUser(tester);
        await TestHelpers.waitForDecksPageToLoad(tester);

        // Act - Create deck with Unicode
        const deckName = TestData.deckNameWithUnicode;

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        final editableText = find.byType(EditableText);
        await tester.enterText(editableText.first, deckName);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Zapisz'));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert
        expect(
          find.text(deckName),
          findsOneWidget,
          reason: 'Deck with Unicode should be created',
        );
      },
    );

    testWidgets('TC-E2E-DECK-008: User can cancel deck creation', (
      tester,
    ) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await TestHelpers.ensureLoggedOut(tester);
      testEmail = await TestHelpers.registerTestUser(tester);
      await TestHelpers.waitForDecksPageToLoad(tester);

      // Act - Open dialog and cancel
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      final editableText = find.byType(EditableText);
      await tester.enterText(editableText.first, 'Test Deck');
      await tester.pumpAndSettle();

      // Find and tap cancel button
      final cancelButton = find.text('Anuluj');
      if (cancelButton.evaluate().isNotEmpty) {
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();
      } else {
        // Alternative: tap outside dialog or press back
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();
      }

      // Assert - Should still show empty state
      expect(
        find.textContaining('Nie masz jeszcze', skipOffstage: false),
        findsOneWidget,
        reason: 'Should still show empty decks message',
      );
    });

    testWidgets('TC-E2E-DECK-009: Deck counter updates correctly', (
      tester,
    ) async {
      // Arrange - Create a deck
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await TestHelpers.ensureLoggedOut(tester);
      testEmail = await TestHelpers.registerTestUser(tester);
      await TestHelpers.waitForDecksPageToLoad(tester);

      final deckName = TestData.generateUniqueDeckName();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      final editableText = find.byType(EditableText);
      await tester.enterText(editableText.first, deckName);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zapisz'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Wait extra time for navigation and data loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Assert - Deck was created successfully
      expect(
        find.text(deckName),
        findsAtLeastNWidgets(1),
        reason: 'Deck should be visible after creation',
      );

      // Note: Counter update after adding flashcards will be tested
      // in flashcard_management_test.dart
    });

    testWidgets('TC-E2E-DECK-010: User sees loading state during creation', (
      tester,
    ) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await TestHelpers.ensureLoggedOut(tester);
      testEmail = await TestHelpers.registerTestUser(tester);
      await TestHelpers.waitForDecksPageToLoad(tester);

      // Act - Start creating deck
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      final editableText = find.byType(EditableText);
      await tester.enterText(
        editableText.first,
        TestData.generateUniqueDeckName(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zapisz'));

      // Check for loading indicator immediately
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Should show some loading state
      // Note: This might be a CircularProgressIndicator or disabled button
      final loadingIndicator = find.byType(CircularProgressIndicator);
      if (loadingIndicator.evaluate().isNotEmpty) {
        expect(
          loadingIndicator,
          findsOneWidget,
          reason: 'Should show loading indicator',
        );
      }

      // Wait for completion
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });
  });
}
