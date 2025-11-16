import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_model.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_state.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/add_edit_flashcard_dialog.dart';

class MockFlashcardCubit extends Mock implements FlashcardCubit {}

void main() {
  late MockFlashcardCubit mockFlashcardCubit;
  late StreamController<FlashcardState> stateController;

  setUp(() {
    mockFlashcardCubit = MockFlashcardCubit();
    stateController = StreamController<FlashcardState>.broadcast();

    when(() => mockFlashcardCubit.state)
        .thenReturn(const FlashcardState.initial());
    when(() => mockFlashcardCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockFlashcardCubit.close())
        .thenAnswer((_) async => stateController.close());
    when(
      () => mockFlashcardCubit.createFlashcard(
        deckId: any(named: 'deckId'),
        front: any(named: 'front'),
        back: any(named: 'back'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockFlashcardCubit.updateFlashcard(
        deckId: any(named: 'deckId'),
        flashcardId: any(named: 'flashcardId'),
        newFront: any(named: 'newFront'),
        newBack: any(named: 'newBack'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest({FlashcardModel? initialData}) {
    return ShadApp(
      home: Scaffold(
        body: BlocProvider<FlashcardCubit>.value(
          value: mockFlashcardCubit,
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showShadDialog(
                  context: context,
                  builder: (context) => BlocProvider<FlashcardCubit>.value(
                    value: mockFlashcardCubit,
                    child: AddEditFlashcardDialog(
                      deckId: 1,
                      initialData: initialData,
                    ),
                  ),
                );
              },
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      ),
    );
  }

  group('AddEditFlashcardDialog Widget Tests', () {
    testWidgets('should render dialog with add title when no flashcard provided',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Dodaj fiszkę'), findsOneWidget);
      expect(find.text('Zapisz'), findsOneWidget);
      expect(find.text('Przód'), findsOneWidget);
      expect(find.text('Tył'), findsOneWidget);
      expect(find.byType(ShadInputFormField), findsNWidgets(2));
    });

    testWidgets('should render dialog with edit title when flashcard provided',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'Test Front',
        back: 'Test Back',
        isAiGenerated: false,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(initialData: flashcard));
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Edytuj fiszkę'), findsOneWidget);
      expect(find.text('Test Front'), findsOneWidget);
      expect(find.text('Test Back'), findsOneWidget);
    });

    testWidgets('should pre-fill fields when editing existing flashcard',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'Existing Front',
        back: 'Existing Back',
        isAiGenerated: false,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(initialData: flashcard));
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Assert - Fields should be pre-filled
      expect(find.text('Existing Front'), findsOneWidget);
      expect(find.text('Existing Back'), findsOneWidget);
    });

    testWidgets('should call createFlashcard when adding new flashcard',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Fill in fields
      final frontField = find.widgetWithText(ShadInputFormField, 'Przód');
      final backField = find.widgetWithText(ShadInputFormField, 'Tył');

      await tester.enterText(frontField, 'New Front');
      await tester.pumpAndSettle();
      await tester.enterText(backField, 'New Back');
      await tester.pumpAndSettle();

      // Tap save button
      final saveButton = find.widgetWithText(ShadButton, 'Zapisz');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockFlashcardCubit.createFlashcard(
          deckId: 1,
          front: 'New Front',
          back: 'New Back',
        ),
      ).called(1);
    });

    testWidgets('should call updateFlashcard when editing existing flashcard',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'Old Front',
        back: 'Old Back',
        isAiGenerated: false,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createWidgetUnderTest(initialData: flashcard));
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Modify fields
      final frontField = find.widgetWithText(ShadInputFormField, 'Przód');
      final backField = find.widgetWithText(ShadInputFormField, 'Tył');

      await tester.enterText(frontField, 'Updated Front');
      await tester.pumpAndSettle();
      await tester.enterText(backField, 'Updated Back');
      await tester.pumpAndSettle();

      // Tap save button
      final saveButton = find.widgetWithText(ShadButton, 'Zapisz');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockFlashcardCubit.updateFlashcard(
          deckId: 1,
          flashcardId: 1,
          newFront: 'Updated Front',
          newBack: 'Updated Back',
        ),
      ).called(1);
    });

    testWidgets('should handle special characters in flashcard content',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Enter text with special characters
      final frontField = find.widgetWithText(ShadInputFormField, 'Przód');
      final backField = find.widgetWithText(ShadInputFormField, 'Tył');

      await tester.enterText(frontField, 'Front: Test & Learn! 📚');
      await tester.pumpAndSettle();
      await tester.enterText(backField, 'Back: Answer #1 (100%)');
      await tester.pumpAndSettle();

      // Tap save button
      final saveButton = find.widgetWithText(ShadButton, 'Zapisz');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockFlashcardCubit.createFlashcard(
          deckId: 1,
          front: 'Front: Test & Learn! 📚',
          back: 'Back: Answer #1 (100%)',
        ),
      ).called(1);
    });

    testWidgets('should handle multiline text in back field',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Enter multiline text
      final frontField = find.widgetWithText(ShadInputFormField, 'Przód');
      final backField = find.widgetWithText(ShadInputFormField, 'Tył');

      await tester.enterText(frontField, 'Question');
      await tester.pumpAndSettle();
      await tester.enterText(backField, 'Line 1\nLine 2\nLine 3');
      await tester.pumpAndSettle();

      // Tap save button
      final saveButton = find.widgetWithText(ShadButton, 'Zapisz');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockFlashcardCubit.createFlashcard(
          deckId: 1,
          front: 'Question',
          back: 'Line 1\nLine 2\nLine 3',
        ),
      ).called(1);
    });
  });
}

