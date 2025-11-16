import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_state.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/generate_with_ai_dialog.dart';

class MockAiGenerationCubit extends Mock implements AiGenerationCubit {}

void main() {
  late MockAiGenerationCubit mockAiGenerationCubit;
  late StreamController<AiGenerationState> stateController;

  setUp(() {
    mockAiGenerationCubit = MockAiGenerationCubit();
    stateController = StreamController<AiGenerationState>.broadcast();

    when(() => mockAiGenerationCubit.state)
        .thenReturn(const AiGenerationState.initial());
    when(() => mockAiGenerationCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockAiGenerationCubit.close())
        .thenAnswer((_) async => stateController.close());
    when(() => mockAiGenerationCubit.generateFlashcards(any()))
        .thenAnswer((_) async {});
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest() {
    return ShadApp(
      home: Scaffold(
        body: BlocProvider<AiGenerationCubit>.value(
          value: mockAiGenerationCubit,
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showShadDialog(
                  context: context,
                  builder: (context) => BlocProvider<AiGenerationCubit>.value(
                    value: mockAiGenerationCubit,
                    child: const GenerateWithAiDialog(),
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

  group('GenerateWithAiDialog Widget Tests', () {
    testWidgets('should render dialog with correct title and button',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Generuj fiszki z AI'), findsOneWidget);
      expect(find.text('Generuj'), findsOneWidget);
      expect(find.byType(ShadInputFormField), findsOneWidget);
    });

    testWidgets('should have placeholder text in input field',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Wklej tutaj tekst, z którego AI ma stworzyć fiszki...'),
        findsOneWidget,
      );
    });

    testWidgets('should call generateFlashcards when generate button is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Enter text
      final textField = find.byType(ShadInputFormField);
      await tester.enterText(textField, 'Sample text for AI generation');
      await tester.pumpAndSettle();

      // Tap generate button
      final generateButton = find.widgetWithText(ShadButton, 'Generuj');
      await tester.tap(generateButton);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockAiGenerationCubit.generateFlashcards(
            'Sample text for AI generation',
          )).called(1);
    });

    testWidgets('should handle long text input',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Enter long text
      final longText = 'A' * 5000;
      final textField = find.byType(ShadInputFormField);
      await tester.enterText(textField, longText);
      await tester.pumpAndSettle();

      // Tap generate button
      final generateButton = find.widgetWithText(ShadButton, 'Generuj');
      await tester.tap(generateButton);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockAiGenerationCubit.generateFlashcards(longText))
          .called(1);
    });

    testWidgets('should handle multiline text input',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Enter multiline text
      const multilineText = 'Line 1\nLine 2\nLine 3\nLine 4';
      final textField = find.byType(ShadInputFormField);
      await tester.enterText(textField, multilineText);
      await tester.pumpAndSettle();

      // Tap generate button
      final generateButton = find.widgetWithText(ShadButton, 'Generuj');
      await tester.tap(generateButton);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockAiGenerationCubit.generateFlashcards(multilineText))
          .called(1);
    });

    testWidgets('should handle special characters in text input',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Enter text with special characters
      const specialText = 'Text with special chars: @#\$%^&*()_+{}[]|\\:";\'<>?,./';
      final textField = find.byType(ShadInputFormField);
      await tester.enterText(textField, specialText);
      await tester.pumpAndSettle();

      // Tap generate button
      final generateButton = find.widgetWithText(ShadButton, 'Generuj');
      await tester.tap(generateButton);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockAiGenerationCubit.generateFlashcards(specialText))
          .called(1);
    });

    testWidgets('should handle emojis in text input',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Act - Enter text with emojis
      const emojiText = 'Text with emojis 📚 🎓 ✨ 🚀';
      final textField = find.byType(ShadInputFormField);
      await tester.enterText(textField, emojiText);
      await tester.pumpAndSettle();

      // Tap generate button
      final generateButton = find.widgetWithText(ShadButton, 'Generuj');
      await tester.tap(generateButton);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockAiGenerationCubit.generateFlashcards(emojiText))
          .called(1);
    });
  });
}

