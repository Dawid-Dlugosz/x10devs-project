import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/flashcard_error_view.dart';

void main() {
  Widget createWidgetUnderTest({
    required Failure failure,
    required VoidCallback onRetry,
  }) {
    return ShadApp(
      home: Scaffold(
        body: FlashcardErrorView(
          failure: failure,
          onRetry: onRetry,
        ),
      ),
    );
  }

  group('FlashcardErrorView Widget Tests', () {
    testWidgets('should render error title',
        (WidgetTester tester) async {
      // Arrange
      const failure = Failure.serverFailure(message: 'Test error');
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          failure: failure,
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.text('Wystąpił błąd'), findsOneWidget);
    });

    testWidgets('should render error message',
        (WidgetTester tester) async {
      // Arrange
      const failure = Failure.serverFailure(message: 'Connection failed');
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          failure: failure,
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.text('Connection failed'), findsOneWidget);
    });

    testWidgets('should render retry button',
        (WidgetTester tester) async {
      // Arrange
      const failure = Failure.serverFailure(message: 'Test error');
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          failure: failure,
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.text('Spróbuj ponownie'), findsOneWidget);
      expect(find.widgetWithText(ShadButton, 'Spróbuj ponownie'), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is tapped',
        (WidgetTester tester) async {
      // Arrange
      const failure = Failure.serverFailure(message: 'Test error');
      var retryCallCount = 0;

      await tester.pumpWidget(
        createWidgetUnderTest(
          failure: failure,
          onRetry: () => retryCallCount++,
        ),
      );

      // Act
      final retryButton = find.widgetWithText(ShadButton, 'Spróbuj ponownie');
      await tester.tap(retryButton);
      await tester.pumpAndSettle();

      // Assert
      expect(retryCallCount, equals(1));
    });

    testWidgets('should render warning icon',
        (WidgetTester tester) async {
      // Arrange
      const failure = Failure.serverFailure(message: 'Test error');
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          failure: failure,
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('should handle different failure types',
        (WidgetTester tester) async {
      // Arrange
      const failure = Failure.authFailure(message: 'Auth error');
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          failure: failure,
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.text('Auth error'), findsOneWidget);
    });
  });
}

