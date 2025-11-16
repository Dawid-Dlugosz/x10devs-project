import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/core/widgets/error_display_widget.dart';

void main() {
  Widget createWidgetUnderTest({
    required String errorMessage,
    required VoidCallback onRetry,
  }) {
    return ShadApp(
      home: Scaffold(
        body: ErrorDisplayWidget(
          errorMessage: errorMessage,
          onRetry: onRetry,
        ),
      ),
    );
  }

  group('ErrorDisplayWidget Widget Tests', () {
    testWidgets('should render error message',
        (WidgetTester tester) async {
      // Arrange
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          errorMessage: 'Test error message',
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.text('Wystąpił błąd: Test error message'), findsOneWidget);
    });

    testWidgets('should render retry button',
        (WidgetTester tester) async {
      // Arrange
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          errorMessage: 'Test error',
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
      var retryCallCount = 0;

      await tester.pumpWidget(
        createWidgetUnderTest(
          errorMessage: 'Test error',
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

    testWidgets('should handle empty error message',
        (WidgetTester tester) async {
      // Arrange
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          errorMessage: '',
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.text('Wystąpił błąd: '), findsOneWidget);
    });

    testWidgets('should handle long error message',
        (WidgetTester tester) async {
      // Arrange
      var retryCallCount = 0;
      const longMessage = 'This is a very long error message that should be displayed properly';

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          errorMessage: longMessage,
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.text('Wystąpił błąd: $longMessage'), findsOneWidget);
    });

    testWidgets('should be centered on screen',
        (WidgetTester tester) async {
      // Arrange
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          errorMessage: 'Test error',
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should have column layout',
        (WidgetTester tester) async {
      // Arrange
      var retryCallCount = 0;

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          errorMessage: 'Test error',
          onRetry: () => retryCallCount++,
        ),
      );

      // Assert
      expect(find.byType(Column), findsOneWidget);
    });
  });
}

