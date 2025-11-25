import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_model.dart';
import 'package:x10devs/features/flashcard/data/repositories/flashcard_repository_impl.dart';
import 'package:x10devs/features/flashcard/domain/data_sources/flashcard_remote_data_source.dart';

class MockFlashcardsRemoteDataSource extends Mock
    implements IFlashcardsRemoteDataSource {}

void main() {
  late FlashcardRepositoryImpl repository;
  late MockFlashcardsRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockFlashcardsRemoteDataSource();
    repository = FlashcardRepositoryImpl(mockDataSource);
  });

  final mockFlashcard = FlashcardModel(
    id: 1,
    deckId: 1,
    front: 'Test Front',
    back: 'Test Back',
    isAiGenerated: false,
    wasModifiedByUser: false,
    createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
  );

  group('FlashcardRepositoryImpl', () {
    group('getFlashcardsForDeck', () {
      const testDeckId = 1;

      test(
        'should return Right(List<FlashcardModel>) when successful',
        () async {
          final mockFlashcards = [mockFlashcard];

          when(
            () => mockDataSource.getFlashcardsForDeck(deckId: testDeckId),
          ).thenAnswer((_) async => mockFlashcards);

          final result = await repository.getFlashcardsForDeck(
            deckId: testDeckId,
          );

          expect(result, isA<Right<Failure, List<FlashcardModel>>>());
          result.fold((failure) => fail('Should not return failure'), (
            flashcards,
          ) {
            expect(flashcards, equals(mockFlashcards));
            expect(flashcards.length, equals(1));
          });
          verify(
            () => mockDataSource.getFlashcardsForDeck(deckId: testDeckId),
          ).called(1);
        },
      );

      test(
        'should return Right(empty list) when no flashcards exist',
        () async {
          when(
            () => mockDataSource.getFlashcardsForDeck(deckId: testDeckId),
          ).thenAnswer((_) async => []);

          final result = await repository.getFlashcardsForDeck(
            deckId: testDeckId,
          );

          expect(result, isA<Right<Failure, List<FlashcardModel>>>());
          result.fold(
            (failure) => fail('Should not return failure'),
            (flashcards) => expect(flashcards, isEmpty),
          );
        },
      );

      test(
        'should return Left(ServerFailure) when PostgrestException is thrown',
        () async {
          const errorMessage = 'Database error';

          when(
            () => mockDataSource.getFlashcardsForDeck(deckId: testDeckId),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.getFlashcardsForDeck(
            deckId: testDeckId,
          );

          expect(result, isA<Left<Failure, List<FlashcardModel>>>());
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
          }, (flashcards) => fail('Should not return flashcards'));
        },
      );

      test(
        'should return Left(Failure) when generic exception is thrown',
        () async {
          const errorMessage = 'Unexpected error';

          when(
            () => mockDataSource.getFlashcardsForDeck(deckId: testDeckId),
          ).thenThrow(Exception(errorMessage));

          final result = await repository.getFlashcardsForDeck(
            deckId: testDeckId,
          );

          expect(result, isA<Left<Failure, List<FlashcardModel>>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => expect(message, contains(errorMessage)),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) => fail('Wrong failure type'),
            );
          }, (flashcards) => fail('Should not return flashcards'));
        },
      );
    });

    group('createFlashcard', () {
      const testDeckId = 1;
      const testFront = 'New Front';
      const testBack = 'New Back';

      test(
        'should return Right(FlashcardModel) when flashcard is created',
        () async {
          when(
            () => mockDataSource.createFlashcard(
              deckId: testDeckId,
              front: testFront,
              back: testBack,
              isAiGenerated: false,
            ),
          ).thenAnswer((_) async => mockFlashcard);

          final result = await repository.createFlashcard(
            deckId: testDeckId,
            front: testFront,
            back: testBack,
          );

          expect(result, isA<Right<Failure, FlashcardModel>>());
          result.fold((failure) => fail('Should not return failure'), (
            flashcard,
          ) {
            expect(flashcard, equals(mockFlashcard));
            expect(flashcard.front, equals(mockFlashcard.front));
          });
        },
      );

      test('should pass isAiGenerated parameter correctly', () async {
        when(
          () => mockDataSource.createFlashcard(
            deckId: testDeckId,
            front: testFront,
            back: testBack,
            isAiGenerated: true,
          ),
        ).thenAnswer((_) async => mockFlashcard);

        await repository.createFlashcard(
          deckId: testDeckId,
          front: testFront,
          back: testBack,
          isAiGenerated: true,
        );

        verify(
          () => mockDataSource.createFlashcard(
            deckId: testDeckId,
            front: testFront,
            back: testBack,
            isAiGenerated: true,
          ),
        ).called(1);
      });

      test(
        'should return Left(ServerFailure) when PostgrestException is thrown',
        () async {
          const errorMessage = 'Failed to create flashcard';

          when(
            () => mockDataSource.createFlashcard(
              deckId: testDeckId,
              front: testFront,
              back: testBack,
              isAiGenerated: false,
            ),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.createFlashcard(
            deckId: testDeckId,
            front: testFront,
            back: testBack,
          );

          expect(result, isA<Left<Failure, FlashcardModel>>());
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
          }, (flashcard) => fail('Should not return flashcard'));
        },
      );
    });

    group('createFlashcards', () {
      const testDeckId = 1;

      test('should return Right(void) when flashcards are created', () async {
        final candidates = [
          const FlashcardCandidateModel(
            front: 'Front 1',
            back: 'Back 1',
            wasModified: false,
          ),
          const FlashcardCandidateModel(
            front: 'Front 2',
            back: 'Back 2',
            wasModified: true,
          ),
        ];

        final expectedFlashcards = [
          {
            'deck_id': testDeckId,
            'front': 'Front 1',
            'back': 'Back 1',
            'is_ai_generated': true,
            'was_modified_by_user': false,
          },
          {
            'deck_id': testDeckId,
            'front': 'Front 2',
            'back': 'Back 2',
            'is_ai_generated': true,
            'was_modified_by_user': true,
          },
        ];

        when(
          () => mockDataSource.createFlashcards(
            flashcards: any(named: 'flashcards'),
          ),
        ).thenAnswer((_) async => {});

        final result = await repository.createFlashcards(
          deckId: testDeckId,
          candidates: candidates,
        );

        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (_) => {}, // Success
        );

        final captured =
            verify(
                  () => mockDataSource.createFlashcards(
                    flashcards: captureAny(named: 'flashcards'),
                  ),
                ).captured.single
                as List;

        expect(captured.length, equals(2));
        expect(captured, equals(expectedFlashcards));
      });

      test('should handle empty candidates list', () async {
        when(
          () => mockDataSource.createFlashcards(flashcards: []),
        ).thenAnswer((_) async => {});

        final result = await repository.createFlashcards(
          deckId: testDeckId,
          candidates: [],
        );

        expect(result, isA<Right<Failure, void>>());
      });

      test(
        'should return Left(ServerFailure) when PostgrestException is thrown',
        () async {
          const errorMessage = 'Failed to create flashcards';
          final candidates = [
            const FlashcardCandidateModel(front: 'Front 1', back: 'Back 1'),
          ];

          when(
            () => mockDataSource.createFlashcards(
              flashcards: any(named: 'flashcards'),
            ),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.createFlashcards(
            deckId: testDeckId,
            candidates: candidates,
          );

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
          }, (_) => fail('Should not return void'));
        },
      );
    });

    group('updateFlashcard', () {
      const testFlashcardId = 1;
      const newFront = 'Updated Front';
      const newBack = 'Updated Back';

      test(
        'should return Right(FlashcardModel) when flashcard is updated',
        () async {
          final updatedFlashcard = FlashcardModel(
            id: testFlashcardId,
            deckId: 1,
            front: newFront,
            back: newBack,
            isAiGenerated: false,
            wasModifiedByUser: true,
            createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          );

          when(
            () => mockDataSource.updateFlashcard(
              flashcardId: testFlashcardId,
              newFront: newFront,
              newBack: newBack,
              wasModifiedByUser: true,
            ),
          ).thenAnswer((_) async => updatedFlashcard);

          final result = await repository.updateFlashcard(
            flashcardId: testFlashcardId,
            newFront: newFront,
            newBack: newBack,
          );

          expect(result, isA<Right<Failure, FlashcardModel>>());
          result.fold((failure) => fail('Should not return failure'), (
            flashcard,
          ) {
            expect(flashcard, equals(updatedFlashcard));
            expect(flashcard.front, equals(newFront));
            expect(flashcard.back, equals(newBack));
          });
        },
      );

      test('should pass wasModifiedByUser parameter correctly', () async {
        when(
          () => mockDataSource.updateFlashcard(
            flashcardId: testFlashcardId,
            newFront: newFront,
            newBack: newBack,
            wasModifiedByUser: false,
          ),
        ).thenAnswer((_) async => mockFlashcard);

        await repository.updateFlashcard(
          flashcardId: testFlashcardId,
          newFront: newFront,
          newBack: newBack,
          wasModifiedByUser: false,
        );

        verify(
          () => mockDataSource.updateFlashcard(
            flashcardId: testFlashcardId,
            newFront: newFront,
            newBack: newBack,
            wasModifiedByUser: false,
          ),
        ).called(1);
      });

      test(
        'should return Left(ServerFailure) when PostgrestException is thrown',
        () async {
          const errorMessage = 'Flashcard not found';

          when(
            () => mockDataSource.updateFlashcard(
              flashcardId: testFlashcardId,
              newFront: newFront,
              newBack: newBack,
              wasModifiedByUser: true,
            ),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.updateFlashcard(
            flashcardId: testFlashcardId,
            newFront: newFront,
            newBack: newBack,
          );

          expect(result, isA<Left<Failure, FlashcardModel>>());
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
          }, (flashcard) => fail('Should not return flashcard'));
        },
      );
    });

    group('deleteFlashcard', () {
      const testFlashcardId = 1;

      test('should return Right(void) when flashcard is deleted', () async {
        when(
          () => mockDataSource.deleteFlashcard(flashcardId: testFlashcardId),
        ).thenAnswer((_) async => {});

        final result = await repository.deleteFlashcard(
          flashcardId: testFlashcardId,
        );

        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (_) => {}, // Success
        );
        verify(
          () => mockDataSource.deleteFlashcard(flashcardId: testFlashcardId),
        ).called(1);
      });

      test(
        'should return Left(ServerFailure) when PostgrestException is thrown',
        () async {
          const errorMessage = 'Failed to delete flashcard';

          when(
            () => mockDataSource.deleteFlashcard(flashcardId: testFlashcardId),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.deleteFlashcard(
            flashcardId: testFlashcardId,
          );

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
          }, (_) => fail('Should not return void'));
        },
      );
    });

    group('Edge Cases', () {
      group(
        'TC-FLASHCARD-EDGE-001: Create flashcard with empty front/back',
        () {
          test('should handle empty front text', () async {
            const errorMessage = 'Front cannot be empty';

            when(
              () => mockDataSource.createFlashcard(
                deckId: 1,
                front: '',
                back: 'Back',
                isAiGenerated: false,
              ),
            ).thenThrow(const PostgrestException(message: errorMessage));

            final result = await repository.createFlashcard(
              deckId: 1,
              front: '',
              back: 'Back',
            );

            expect(result, isA<Left<Failure, FlashcardModel>>());
          });

          test('should handle empty back text', () async {
            const errorMessage = 'Back cannot be empty';

            when(
              () => mockDataSource.createFlashcard(
                deckId: 1,
                front: 'Front',
                back: '',
                isAiGenerated: false,
              ),
            ).thenThrow(const PostgrestException(message: errorMessage));

            final result = await repository.createFlashcard(
              deckId: 1,
              front: 'Front',
              back: '',
            );

            expect(result, isA<Left<Failure, FlashcardModel>>());
          });
        },
      );

      group('TC-FLASHCARD-EDGE-005: Get flashcards for non-existent deck', () {
        test('should return empty list for non-existent deck', () async {
          const nonExistentDeckId = 999;

          when(
            () =>
                mockDataSource.getFlashcardsForDeck(deckId: nonExistentDeckId),
          ).thenAnswer((_) async => []);

          final result = await repository.getFlashcardsForDeck(
            deckId: nonExistentDeckId,
          );

          expect(result, isA<Right<Failure, List<FlashcardModel>>>());
          result.fold(
            (failure) => fail('Should not return failure'),
            (flashcards) => expect(flashcards, isEmpty),
          );
        });
      });

      group('TC-FLASHCARD-EDGE-007: Update non-existent flashcard', () {
        test('should handle updating flashcard that does not exist', () async {
          const nonExistentId = 999;
          const errorMessage = 'Flashcard not found';

          when(
            () => mockDataSource.updateFlashcard(
              flashcardId: nonExistentId,
              newFront: 'Front',
              newBack: 'Back',
              wasModifiedByUser: true,
            ),
          ).thenThrow(const PostgrestException(message: errorMessage));

          final result = await repository.updateFlashcard(
            flashcardId: nonExistentId,
            newFront: 'Front',
            newBack: 'Back',
          );

          expect(result, isA<Left<Failure, FlashcardModel>>());
        });
      });

      group('TC-FLASHCARD-EDGE-008: Delete non-existent flashcard', () {
        test('should handle deleting flashcard that does not exist', () async {
          const nonExistentId = 999;

          when(
            () => mockDataSource.deleteFlashcard(flashcardId: nonExistentId),
          ).thenAnswer((_) async => {});

          final result = await repository.deleteFlashcard(
            flashcardId: nonExistentId,
          );

          expect(result, isA<Right<Failure, void>>());
        });
      });

      group('TC-FLASHCARD-EDGE-011: Create flashcards with very long text', () {
        test('should handle very long front/back text', () async {
          final longText = 'A' * 10000;

          when(
            () => mockDataSource.createFlashcard(
              deckId: 1,
              front: longText,
              back: longText,
              isAiGenerated: false,
            ),
          ).thenAnswer((_) async => mockFlashcard);

          final result = await repository.createFlashcard(
            deckId: 1,
            front: longText,
            back: longText,
          );

          expect(result, isA<Right<Failure, FlashcardModel>>());
        });
      });
    });
  });
}
