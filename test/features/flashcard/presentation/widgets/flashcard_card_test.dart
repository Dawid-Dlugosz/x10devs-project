import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_model.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_state.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/flashcard_card.dart';

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
    when(() => mockFlashcardCubit.deleteFlashcard(any(), any()))
        .thenAnswer((_) async {});
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest(FlashcardModel flashcard) {
    return ShadApp(
      home: Scaffold(
        body: BlocProvider<FlashcardCubit>.value(
          value: mockFlashcardCubit,
          child: FlashcardCard(flashcard: flashcard),
        ),
      ),
    );
  }

  group('FlashcardCard Widget Tests', () {
    testWidgets('should render flashcard front and back',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'Question',
        back: 'Answer',
        isAiGenerated: false,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(flashcard));

      // Assert
      expect(find.text('Question'), findsOneWidget);
      expect(find.text('Answer'), findsOneWidget);
      expect(find.byType(ShadCard), findsOneWidget);
    });

    testWidgets('should render edit and delete buttons',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'Question',
        back: 'Answer',
        isAiGenerated: false,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(flashcard));

      // Assert
      expect(find.byIcon(LucideIcons.pencil), findsOneWidget);
      expect(find.byIcon(LucideIcons.trash2), findsOneWidget);
    });

    testWidgets('should call deleteFlashcard when delete button is tapped',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'Question',
        back: 'Answer',
        isAiGenerated: false,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(flashcard));

      // Find and tap delete button
      final deleteButton = find.byIcon(LucideIcons.trash2);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockFlashcardCubit.deleteFlashcard(1, 1)).called(1);
    });

    testWidgets('should handle special characters in flashcard content',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'Question: What is 2+2? 🤔',
        back: 'Answer: 4! ✅',
        isAiGenerated: false,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(flashcard));

      // Assert
      expect(find.text('Question: What is 2+2? 🤔'), findsOneWidget);
      expect(find.text('Answer: 4! ✅'), findsOneWidget);
    });

    testWidgets('should handle multiline text in flashcard',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'Question',
        back: 'Line 1\nLine 2\nLine 3',
        isAiGenerated: false,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(flashcard));

      // Assert
      expect(find.text('Question'), findsOneWidget);
      expect(find.text('Line 1\nLine 2\nLine 3'), findsOneWidget);
    });

    testWidgets('should render AI-generated flashcard',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'AI Question',
        back: 'AI Answer',
        isAiGenerated: true,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(flashcard));

      // Assert
      expect(find.text('AI Question'), findsOneWidget);
      expect(find.text('AI Answer'), findsOneWidget);
    });

    testWidgets('should render modified flashcard',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: 'Modified Question',
        back: 'Modified Answer',
        isAiGenerated: true,
        wasModifiedByUser: true,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(flashcard));

      // Assert
      expect(find.text('Modified Question'), findsOneWidget);
      expect(find.text('Modified Answer'), findsOneWidget);
    });

    testWidgets('should render empty front and back',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = FlashcardModel(
        id: 1,
        deckId: 1,
        front: '',
        back: '',
        isAiGenerated: false,
        wasModifiedByUser: false,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(flashcard));

      // Assert - Should still render the card structure
      expect(find.byType(ShadCard), findsOneWidget);
      expect(find.byIcon(LucideIcons.pencil), findsOneWidget);
      expect(find.byIcon(LucideIcons.trash2), findsOneWidget);
    });
  });
}

