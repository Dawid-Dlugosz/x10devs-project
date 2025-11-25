import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';
import 'package:x10devs/features/decks/data/repositories/decks_repository_impl.dart';
import 'package:x10devs/features/decks/domain/data_sources/decks_remote_data_source.dart';

class MockDecksRemoteDataSource extends Mock
    implements IDecksRemoteDataSource {}

void main() {
  late DecksRepositoryImpl repository;
  late MockDecksRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockDecksRemoteDataSource();
    repository = DecksRepositoryImpl(mockDataSource);
  });

  final mockDeck = DeckModel(
    id: 1,
    userId: 'test-user-id',
    name: 'Test Deck',
    flashcardCount: 0,
    createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
  );

  group('DecksRepositoryImpl', () {
    group('getDecks', () {
      test('should return Right(List<DeckModel>) when successful', () async {
        final mockDecks = [mockDeck];

        when(
          () => mockDataSource.getDecks(),
        ).thenAnswer((_) async => mockDecks);

        final result = await repository.getDecks();

        expect(result, isA<Right<Failure, List<DeckModel>>>());
        result.fold((failure) => fail('Should not return failure'), (decks) {
          expect(decks, equals(mockDecks));
          expect(decks.length, equals(1));
        });
        verify(() => mockDataSource.getDecks()).called(1);
      });

      test('should return Right(empty list) when no decks exist', () async {
        when(() => mockDataSource.getDecks()).thenAnswer((_) async => []);

        final result = await repository.getDecks();

        expect(result, isA<Right<Failure, List<DeckModel>>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (decks) => expect(decks, isEmpty),
        );
      });

      test(
        'should return Left(ServerFailure) when PostgrestException is thrown',
        () async {
          const errorMessage = 'Database error';

          when(
            () => mockDataSource.getDecks(),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.getDecks();

          expect(result, isA<Left<Failure, List<DeckModel>>>());
          result.fold((failure) {
            expect(failure, isA<Failure>());
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => expect(message, equals(errorMessage)),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (decks) => fail('Should not return decks'));
        },
      );
    });

    group('createDeck', () {
      const testDeckName = 'New Test Deck';

      test(
        'should return Right(DeckModel) when deck is created successfully',
        () async {
          when(
            () => mockDataSource.createDeck(name: testDeckName),
          ).thenAnswer((_) async => mockDeck);

          final result = await repository.createDeck(name: testDeckName);

          expect(result, isA<Right<Failure, DeckModel>>());
          result.fold((failure) => fail('Should not return failure'), (deck) {
            expect(deck, equals(mockDeck));
            expect(deck.name, equals(mockDeck.name));
          });
          verify(() => mockDataSource.createDeck(name: testDeckName)).called(1);
        },
      );

      test(
        'should return Left(ServerFailure) when PostgrestException is thrown',
        () async {
          const errorMessage = 'Deck name already exists';

          when(
            () => mockDataSource.createDeck(name: testDeckName),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.createDeck(name: testDeckName);

          expect(result, isA<Left<Failure, DeckModel>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => expect(message, equals(errorMessage)),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (deck) => fail('Should not return deck'));
        },
      );
    });

    group('updateDeck', () {
      const testDeckId = 1;
      const newDeckName = 'Updated Deck Name';

      test(
        'should return Right(DeckModel) when deck is updated successfully',
        () async {
          final updatedDeck = DeckModel(
            id: testDeckId,
            userId: 'test-user-id',
            name: newDeckName,
            flashcardCount: 5,
            createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          );

          when(
            () => mockDataSource.updateDeck(
              deckId: testDeckId,
              newName: newDeckName,
            ),
          ).thenAnswer((_) async => updatedDeck);

          final result = await repository.updateDeck(
            deckId: testDeckId,
            newName: newDeckName,
          );

          expect(result, isA<Right<Failure, DeckModel>>());
          result.fold((failure) => fail('Should not return failure'), (deck) {
            expect(deck, equals(updatedDeck));
            expect(deck.name, equals(newDeckName));
          });
        },
      );

      test(
        'should return Left(ServerFailure) when PostgrestException is thrown',
        () async {
          const errorMessage = 'Deck not found';

          when(
            () => mockDataSource.updateDeck(
              deckId: testDeckId,
              newName: newDeckName,
            ),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.updateDeck(
            deckId: testDeckId,
            newName: newDeckName,
          );

          expect(result, isA<Left<Failure, DeckModel>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => expect(message, equals(errorMessage)),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (deck) => fail('Should not return deck'));
        },
      );
    });

    group('deleteDeck', () {
      const testDeckId = 1;

      test(
        'should return Right(void) when deck is deleted successfully',
        () async {
          when(
            () => mockDataSource.deleteDeck(deckId: testDeckId),
          ).thenAnswer((_) async => {});

          final result = await repository.deleteDeck(deckId: testDeckId);

          expect(result, isA<Right<Failure, void>>());
          result.fold(
            (failure) => fail('Should not return failure'),
            (_) => {}, // Success - void return
          );
          verify(() => mockDataSource.deleteDeck(deckId: testDeckId)).called(1);
        },
      );

      test(
        'should return Left(ServerFailure) when PostgrestException is thrown',
        () async {
          const errorMessage = 'Failed to delete deck';

          when(
            () => mockDataSource.deleteDeck(deckId: testDeckId),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.deleteDeck(deckId: testDeckId);

          expect(result, isA<Left<Failure, void>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => expect(message, equals(errorMessage)),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (value) => fail('Should not return void'));
        },
      );
    });

    group('Edge Cases', () {
      group('TC-REPO-DECK-001: Create deck with duplicate name', () {
        test('should handle duplicate name error', () async {
          const duplicateName = 'Existing Deck';
          const errorMessage = 'duplicate key value violates unique constraint';

          when(
            () => mockDataSource.createDeck(name: duplicateName),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.createDeck(name: duplicateName);

          expect(result, isA<Left<Failure, DeckModel>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) =>
                  expect(message, contains('duplicate')),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (deck) => fail('Should not return deck'));
        });
      });

      group('TC-REPO-DECK-003: Get decks with large number of decks', () {
        test('should handle large list of decks', () async {
          final largeList = List.generate(
            1000,
            (index) => DeckModel(
              id: index,
              userId: 'test-user-id',
              name: 'Deck $index',
              flashcardCount: index,
              createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
            ),
          );

          when(
            () => mockDataSource.getDecks(),
          ).thenAnswer((_) async => largeList);

          final result = await repository.getDecks();

          expect(result, isA<Right<Failure, List<DeckModel>>>());
          result.fold(
            (failure) => fail('Should not return failure'),
            (decks) => expect(decks.length, equals(1000)),
          );
        });
      });

      group('TC-REPO-DECK-004: Handle timeout exception', () {
        test('should map timeout to ServerFailure', () async {
          when(
            () => mockDataSource.getDecks(),
          ).thenThrow(const PostgrestException(message: 'Connection timeout'));

          final result = await repository.getDecks();

          expect(result, isA<Left<Failure, List<DeckModel>>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => expect(message, contains('timeout')),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (decks) => fail('Should not return decks'));
        });
      });

      group('TC-DECK-EDGE-009: Update non-existent deck', () {
        test('should handle updating deck that does not exist', () async {
          const nonExistentId = 999;
          const newName = 'Updated Name';
          const errorMessage = 'Deck not found';

          when(
            () => mockDataSource.updateDeck(
              deckId: nonExistentId,
              newName: newName,
            ),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.updateDeck(
            deckId: nonExistentId,
            newName: newName,
          );

          expect(result, isA<Left<Failure, DeckModel>>());
        });
      });

      group('TC-DECK-EDGE-010: Delete non-existent deck', () {
        test('should handle deleting deck that does not exist', () async {
          const nonExistentId = 999;

          when(
            () => mockDataSource.deleteDeck(deckId: nonExistentId),
          ).thenAnswer((_) async => {});

          final result = await repository.deleteDeck(deckId: nonExistentId);

          expect(result, isA<Right<Failure, void>>());
        });
      });
    });
  });
}
