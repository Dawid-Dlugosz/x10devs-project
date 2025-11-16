import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_cubit.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_state.dart';
import 'package:x10devs/features/decks/presentation/widgets/deck_card_widget.dart';

class MockDecksCubit extends Mock implements DecksCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockDecksCubit mockDecksCubit;
  late StreamController<DecksState> stateController;

  setUp(() {
    mockDecksCubit = MockDecksCubit();
    stateController = StreamController<DecksState>.broadcast();

    when(() => mockDecksCubit.state).thenReturn(const DecksState.initial());
    when(() => mockDecksCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockDecksCubit.close())
        .thenAnswer((_) async => stateController.close());
    when(() => mockDecksCubit.updateDeck(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockDecksCubit.deleteDeck(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest(DeckModel deck) {
    return ShadApp(
      home: Scaffold(
        body: BlocProvider<DecksCubit>.value(
          value: mockDecksCubit,
          child: DeckCardWidget(deck: deck),
        ),
      ),
    );
  }

  group('DeckCardWidget Widget Tests', () {
    testWidgets('should render deck name and flashcard count',
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
      await tester.pumpWidget(createWidgetUnderTest(deck));

      // Assert
      expect(find.text('Test Deck'), findsOneWidget);
      expect(find.text('5 fiszek'), findsOneWidget);
      expect(find.byType(ShadCard), findsOneWidget);
    });

    testWidgets('should render deck with zero flashcards',
        (WidgetTester tester) async {
      // Arrange
      final deck = DeckModel(
        id: 1,
        name: 'Empty Deck',
        userId: 'user-123',
        flashcardCount: 0,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(deck));

      // Assert
      expect(find.text('Empty Deck'), findsOneWidget);
      expect(find.text('0 fiszek'), findsOneWidget);
    });

    testWidgets('should render deck with one flashcard',
        (WidgetTester tester) async {
      // Arrange
      final deck = DeckModel(
        id: 1,
        name: 'Single Card Deck',
        userId: 'user-123',
        flashcardCount: 1,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(deck));

      // Assert
      expect(find.text('Single Card Deck'), findsOneWidget);
      expect(find.text('1 fiszek'), findsOneWidget);
    });

    testWidgets('should render deck with many flashcards',
        (WidgetTester tester) async {
      // Arrange
      final deck = DeckModel(
        id: 1,
        name: 'Large Deck',
        userId: 'user-123',
        flashcardCount: 100,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(deck));

      // Assert
      expect(find.text('Large Deck'), findsOneWidget);
      expect(find.text('100 fiszek'), findsOneWidget);
    });

    testWidgets('should render popup menu button',
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
      await tester.pumpWidget(createWidgetUnderTest(deck));

      // Assert
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('should show menu items when popup menu is tapped',
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
      await tester.pumpWidget(createWidgetUnderTest(deck));
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Zmień nazwę'), findsOneWidget);
      expect(find.text('Usuń'), findsOneWidget);
    });

    testWidgets('should handle special characters in deck name',
        (WidgetTester tester) async {
      // Arrange
      final deck = DeckModel(
        id: 1,
        name: 'Deck #1: Test & Learn! 📚',
        userId: 'user-123',
        flashcardCount: 5,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(deck));

      // Assert
      expect(find.text('Deck #1: Test & Learn! 📚'), findsOneWidget);
    });

  });
}

