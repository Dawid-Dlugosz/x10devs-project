import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';
import 'package:x10devs/features/decks/presentation/widgets/dialogs/create_or_edit_deck_dialog.dart';

void main() {
  Widget createWidgetUnderTest({DeckModel? deckToEdit}) {
    return ShadApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              final result = await showCreateOrEditDeckDialog(
                context,
                deck: deckToEdit,
              );
              // Store result for testing
              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
              }
            },
            child: const Text('Open Dialog'),
          ),
        ),
      ),
    );
  }

  group('CreateOrEditDeckDialog Widget Tests', () {
    testWidgets('should render dialog with create title when no deck provided',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Stwórz nową talię'), findsOneWidget);
      expect(find.text('Zapisz'), findsOneWidget);
      expect(find.text('Anuluj'), findsOneWidget);
      expect(find.byType(ShadInputFormField), findsOneWidget);
    });

    testWidgets('should render dialog with edit title when deck provided',
        (WidgetTester tester) async {
      // Arrange
      final deck = DeckModel(
        id: 1,
        name: 'Test Deck',
        userId: 'user-123',
        flashcardCount: 5,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(deckToEdit: deck));
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Edytuj talię'), findsOneWidget);
      expect(find.text('Test Deck'), findsOneWidget);
    });

    testWidgets('should pre-fill name field when editing existing deck',
        (WidgetTester tester) async {
      // Arrange
      final deck = DeckModel(
        id: 1,
        name: 'Existing Deck',
        userId: 'user-123',
        flashcardCount: 5,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(deckToEdit: deck));
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Assert - Field should be pre-filled
      expect(find.text('Existing Deck'), findsOneWidget);
    });

    testWidgets('should handle special characters in deck name',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Enter name with special characters
      final nameField = find.byType(ShadInputFormField);
      await tester.enterText(nameField, 'Deck #1: Test & Learn! 📚');
      await tester.pumpAndSettle();

      // Find save button by type and tap it
      final saveButton = find.widgetWithText(ShadButton, 'Zapisz');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Assert - Should accept special characters and close dialog
      expect(find.text('Deck #1: Test & Learn! 📚'), findsOneWidget);
    });
  });
}

