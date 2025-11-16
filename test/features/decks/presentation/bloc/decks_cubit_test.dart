import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';
import 'package:x10devs/features/decks/domain/repositories/decks_repository.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_cubit.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_state.dart';

class MockDecksRepository extends Mock implements IDecksRepository {}

void main() {
  late DecksCubit cubit;
  late MockDecksRepository mockRepository;

  setUp(() {
    mockRepository = MockDecksRepository();
    cubit = DecksCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  final mockDeck = DeckModel(
    id: 1,
    userId: 'test-user-id',
    name: 'Test Deck',
    flashcardCount: 5,
    createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
  );

  group('DecksCubit', () {
    group('initial state', () {
      test('should have initial state', () {
        expect(cubit.state, equals(const DecksState.initial()));
      });
    });

    group('getDecks', () {
      test('should emit [loading, loaded] when getDecks succeeds', () async {
        final mockDecks = [mockDeck];

        when(() => mockRepository.getDecks())
            .thenAnswer((_) async => Right(mockDecks));

        final expected = [
          const DecksState.loading(),
          DecksState.loaded(decks: mockDecks),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.getDecks();
      });

      test('should emit [loading, loaded] with empty list when no decks exist',
          () async {
        when(() => mockRepository.getDecks())
            .thenAnswer((_) async => const Right([]));

        final expected = [
          const DecksState.loading(),
          const DecksState.loaded(decks: []),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.getDecks();
      });

      test('should emit [loading, error] when getDecks fails', () async {
        const failure = Failure.serverFailure(message: 'Database error');

        when(() => mockRepository.getDecks())
            .thenAnswer((_) async => const Left(failure));

        final expected = [
          const DecksState.loading(),
          const DecksState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.getDecks();
      });
    });

    group('createDeck', () {
      const testDeckName = 'New Test Deck';

      test('should emit [loading, created] when createDeck succeeds', () async {
        when(() => mockRepository.createDeck(name: testDeckName))
            .thenAnswer((_) async => Right(mockDeck));

        final expected = [
          const DecksState.loading(),
          DecksState.created(deck: mockDeck),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.createDeck(testDeckName);
      });

      test('should emit [loading, error] when createDeck fails', () async {
        const failure =
            Failure.serverFailure(message: 'Deck name already exists');

        when(() => mockRepository.createDeck(name: testDeckName))
            .thenAnswer((_) async => const Left(failure));

        final expected = [
          const DecksState.loading(),
          const DecksState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.createDeck(testDeckName);
      });

      test('should call repository.createDeck with correct parameters',
          () async {
        when(() => mockRepository.createDeck(name: testDeckName))
            .thenAnswer((_) async => Right(mockDeck));

        await cubit.createDeck(testDeckName);

        verify(() => mockRepository.createDeck(name: testDeckName)).called(1);
      });
    });

    group('updateDeck', () {
      const testDeckId = 1;
      const newDeckName = 'Updated Deck Name';

      test('should emit [loading, loaded] when updateDeck succeeds',
          () async {
        final mockDecks = [mockDeck];

        when(
          () => mockRepository.updateDeck(
            deckId: testDeckId,
            newName: newDeckName,
          ),
        ).thenAnswer((_) async => Right(mockDeck));

        when(() => mockRepository.getDecks())
            .thenAnswer((_) async => Right(mockDecks));

        final expected = [
          const DecksState.loading(),
          DecksState.loaded(decks: mockDecks),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.updateDeck(testDeckId, newDeckName);
      });

      test('should emit [loading, error] when updateDeck fails', () async {
        const failure = Failure.serverFailure(message: 'Deck not found');

        when(
          () => mockRepository.updateDeck(
            deckId: testDeckId,
            newName: newDeckName,
          ),
        ).thenAnswer((_) async => const Left(failure));

        final expected = [
          const DecksState.loading(),
          const DecksState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.updateDeck(testDeckId, newDeckName);
      });
    });

    group('deleteDeck', () {
      const testDeckId = 1;

      test('should emit [loading, loaded] when deleteDeck succeeds',
          () async {
        final mockDecks = <DeckModel>[];

        when(() => mockRepository.deleteDeck(deckId: testDeckId))
            .thenAnswer((_) async => const Right(null));

        when(() => mockRepository.getDecks())
            .thenAnswer((_) async => Right(mockDecks));

        final expected = [
          const DecksState.loading(),
          DecksState.loaded(decks: mockDecks),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.deleteDeck(testDeckId);
      });

      test('should emit [loading, error] when deleteDeck fails', () async {
        const failure =
            Failure.serverFailure(message: 'Failed to delete deck');

        when(() => mockRepository.deleteDeck(deckId: testDeckId))
            .thenAnswer((_) async => const Left(failure));

        final expected = [
          const DecksState.loading(),
          const DecksState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.deleteDeck(testDeckId);
      });
    });

    group('updateDeckFlashcardCount', () {
      test('should update flashcard count when state is loaded', () {
        final deck1 = DeckModel(
          id: 1,
          userId: 'test-user-id',
          name: 'Deck 1',
          flashcardCount: 5,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );
        final deck2 = DeckModel(
          id: 2,
          userId: 'test-user-id',
          name: 'Deck 2',
          flashcardCount: 10,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final initialDecks = [deck1, deck2];
        cubit.emit(DecksState.loaded(decks: initialDecks));

        cubit.updateDeckFlashcardCount(1, 8);

        expect(cubit.state, isA<DecksState>());
        cubit.state.maybeMap(
          loaded: (state) {
            expect(state.decks.length, equals(2));
            expect(state.decks[0].flashcardCount, equals(8));
            expect(state.decks[1].flashcardCount, equals(10));
          },
          orElse: () => fail('State should be loaded'),
        );
      });

      test('should not update when state is not loaded', () {
        cubit.emit(const DecksState.loading());

        cubit.updateDeckFlashcardCount(1, 8);

        expect(cubit.state, equals(const DecksState.loading()));
      });

      test('should not change other decks when updating one deck', () {
        final deck1 = DeckModel(
          id: 1,
          userId: 'test-user-id',
          name: 'Deck 1',
          flashcardCount: 5,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );
        final deck2 = DeckModel(
          id: 2,
          userId: 'test-user-id',
          name: 'Deck 2',
          flashcardCount: 10,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );
        final deck3 = DeckModel(
          id: 3,
          userId: 'test-user-id',
          name: 'Deck 3',
          flashcardCount: 15,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final initialDecks = [deck1, deck2, deck3];
        cubit.emit(DecksState.loaded(decks: initialDecks));

        cubit.updateDeckFlashcardCount(2, 20);

        cubit.state.maybeMap(
          loaded: (state) {
            expect(state.decks[0].flashcardCount, equals(5)); // unchanged
            expect(state.decks[1].flashcardCount, equals(20)); // updated
            expect(state.decks[2].flashcardCount, equals(15)); // unchanged
          },
          orElse: () => fail('State should be loaded'),
        );
      });
    });

    group('Edge Cases', () {
      group('TC-DECK-EDGE-001: Create deck with empty name', () {
        test('should handle empty deck name', () async {
          const emptyName = '';
          const failure = Failure.serverFailure(message: 'Name cannot be empty');

          when(() => mockRepository.createDeck(name: emptyName))
              .thenAnswer((_) async => const Left(failure));

          final expected = [
            const DecksState.loading(),
            const DecksState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.createDeck(emptyName);
        });
      });

      group('TC-DECK-EDGE-002: Create deck with whitespace-only name', () {
        test('should handle whitespace-only name', () async {
          const whitespaceName = '     ';
          const failure = Failure.serverFailure(message: 'Invalid name');

          when(() => mockRepository.createDeck(name: whitespaceName))
              .thenAnswer((_) async => const Left(failure));

          final expected = [
            const DecksState.loading(),
            const DecksState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.createDeck(whitespaceName);
        });
      });

      group('TC-DECK-EDGE-014: updateDeckFlashcardCount when state is not loaded',
          () {
        test('should do nothing when state is initial', () {
          cubit.emit(const DecksState.initial());

          cubit.updateDeckFlashcardCount(1, 10);

          expect(cubit.state, equals(const DecksState.initial()));
        });

        test('should do nothing when state is error', () {
          const failure = Failure.serverFailure(message: 'Error');
          cubit.emit(const DecksState.error(failure: failure));

          cubit.updateDeckFlashcardCount(1, 10);

          expect(cubit.state, equals(const DecksState.error(failure: failure)));
        });
      });

      group('TC-DECK-EDGE-015: updateDeckFlashcardCount for non-existent deck',
          () {
        test('should not crash when deck id does not exist', () {
          final deck1 = DeckModel(
            id: 1,
            userId: 'test-user-id',
            name: 'Deck 1',
            flashcardCount: 5,
            createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          );

          cubit.emit(DecksState.loaded(decks: [deck1]));

          cubit.updateDeckFlashcardCount(999, 10); // non-existent id

          cubit.state.maybeMap(
            loaded: (state) {
              expect(state.decks.length, equals(1));
              expect(state.decks[0].flashcardCount, equals(5)); // unchanged
            },
            orElse: () => fail('State should be loaded'),
          );
        });
      });
    });
  });
}

