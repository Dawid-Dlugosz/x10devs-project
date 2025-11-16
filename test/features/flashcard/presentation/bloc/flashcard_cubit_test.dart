import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_cubit.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_model.dart';
import 'package:x10devs/features/flashcard/domain/repositories/flashcard_repository.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_state.dart';

class MockFlashcardRepository extends Mock implements IFlashcardRepository {}

class MockDecksCubit extends Mock implements DecksCubit {}

void main() {
  late FlashcardCubit cubit;
  late MockFlashcardRepository mockRepository;
  late MockDecksCubit mockDecksCubit;
  final getIt = GetIt.instance;

  setUp(() {
    mockRepository = MockFlashcardRepository();
    mockDecksCubit = MockDecksCubit();
    
    // Register DecksCubit mock in GetIt
    if (getIt.isRegistered<DecksCubit>()) {
      getIt.unregister<DecksCubit>();
    }
    getIt.registerSingleton<DecksCubit>(mockDecksCubit);
    
    cubit = FlashcardCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
    if (getIt.isRegistered<DecksCubit>()) {
      getIt.unregister<DecksCubit>();
    }
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

  group('FlashcardCubit', () {
    group('initial state', () {
      test('should have initial state', () {
        expect(cubit.state, equals(const FlashcardState.initial()));
      });
    });

    group('getFlashcards', () {
      const testDeckId = 1;

      test('should emit [loading, loaded] when getFlashcards succeeds',
          () async {
        final mockFlashcards = [mockFlashcard];

        when(() => mockRepository.getFlashcardsForDeck(deckId: testDeckId))
            .thenAnswer((_) async => Right(mockFlashcards));
        when(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 1))
            .thenReturn(null);

        final expected = [
          const FlashcardState.loading(),
          FlashcardState.loaded(flashcards: mockFlashcards),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.getFlashcards(testDeckId);

        verify(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 1))
            .called(1);
      });

      test('should emit [loading, loaded] with empty list when no flashcards',
          () async {
        when(() => mockRepository.getFlashcardsForDeck(deckId: testDeckId))
            .thenAnswer((_) async => const Right([]));
        when(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 0))
            .thenReturn(null);

        final expected = [
          const FlashcardState.loading(),
          const FlashcardState.loaded(flashcards: []),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.getFlashcards(testDeckId);

        verify(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 0))
            .called(1);
      });

      test('should emit [loading, error] when getFlashcards fails', () async {
        const failure = Failure.serverFailure(message: 'Database error');

        when(() => mockRepository.getFlashcardsForDeck(deckId: testDeckId))
            .thenAnswer((_) async => const Left(failure));

        final expected = [
          const FlashcardState.loading(),
          const FlashcardState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.getFlashcards(testDeckId);

        verifyNever(() => mockDecksCubit.updateDeckFlashcardCount(any(), any()));
      });
    });

    group('createFlashcard', () {
      const testDeckId = 1;
      const testFront = 'New Front';
      const testBack = 'New Back';

      test('should emit [loading, loaded] when createFlashcard succeeds',
          () async {
        final mockFlashcards = [mockFlashcard];

        when(
          () => mockRepository.createFlashcard(
            deckId: testDeckId,
            front: testFront,
            back: testBack,
            isAiGenerated: false,
          ),
        ).thenAnswer((_) async => Right(mockFlashcard));

        when(() => mockRepository.getFlashcardsForDeck(deckId: testDeckId))
            .thenAnswer((_) async => Right(mockFlashcards));
        when(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 1))
            .thenReturn(null);

        final expected = [
          const FlashcardState.loading(),
          FlashcardState.loaded(flashcards: mockFlashcards),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.createFlashcard(
          deckId: testDeckId,
          front: testFront,
          back: testBack,
        );
      });

      test('should pass isAiGenerated parameter correctly', () async {
        final mockFlashcards = [mockFlashcard];

        when(
          () => mockRepository.createFlashcard(
            deckId: testDeckId,
            front: testFront,
            back: testBack,
            isAiGenerated: true,
          ),
        ).thenAnswer((_) async => Right(mockFlashcard));

        when(() => mockRepository.getFlashcardsForDeck(deckId: testDeckId))
            .thenAnswer((_) async => Right(mockFlashcards));
        when(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 1))
            .thenReturn(null);

        await cubit.createFlashcard(
          deckId: testDeckId,
          front: testFront,
          back: testBack,
          isAiGenerated: true,
        );

        verify(
          () => mockRepository.createFlashcard(
            deckId: testDeckId,
            front: testFront,
            back: testBack,
            isAiGenerated: true,
          ),
        ).called(1);
      });

      test('should emit [loading, error] when createFlashcard fails', () async {
        const failure = Failure.serverFailure(message: 'Failed to create');

        when(
          () => mockRepository.createFlashcard(
            deckId: testDeckId,
            front: testFront,
            back: testBack,
            isAiGenerated: false,
          ),
        ).thenAnswer((_) async => const Left(failure));

        final expected = [
          const FlashcardState.loading(),
          const FlashcardState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.createFlashcard(
          deckId: testDeckId,
          front: testFront,
          back: testBack,
        );
      });
    });

    group('createFlashcards', () {
      const testDeckId = 1;

      test('should emit [loading, loaded] when createFlashcards succeeds',
          () async {
        final candidates = [
          const FlashcardCandidateModel(
            front: 'Front 1',
            back: 'Back 1',
          ),
          const FlashcardCandidateModel(
            front: 'Front 2',
            back: 'Back 2',
          ),
        ];

        final mockFlashcards = [mockFlashcard, mockFlashcard];

        when(
          () => mockRepository.createFlashcards(
            deckId: testDeckId,
            candidates: candidates,
          ),
        ).thenAnswer((_) async => const Right(null));

        when(() => mockRepository.getFlashcardsForDeck(deckId: testDeckId))
            .thenAnswer((_) async => Right(mockFlashcards));
        when(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 2))
            .thenReturn(null);

        final expected = [
          const FlashcardState.loading(),
          FlashcardState.loaded(flashcards: mockFlashcards),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.createFlashcards(
          deckId: testDeckId,
          candidates: candidates,
        );
      });

      test('should emit [loading, error] when createFlashcards fails',
          () async {
        const failure = Failure.serverFailure(message: 'Failed to create');
        final candidates = [
          const FlashcardCandidateModel(front: 'Front', back: 'Back'),
        ];

        when(
          () => mockRepository.createFlashcards(
            deckId: testDeckId,
            candidates: candidates,
          ),
        ).thenAnswer((_) async => const Left(failure));

        final expected = [
          const FlashcardState.loading(),
          const FlashcardState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.createFlashcards(
          deckId: testDeckId,
          candidates: candidates,
        );
      });
    });

    group('updateFlashcard', () {
      const testDeckId = 1;
      const testFlashcardId = 1;
      const newFront = 'Updated Front';
      const newBack = 'Updated Back';

      test('should emit [loading, loaded] when updateFlashcard succeeds',
          () async {
        final updatedFlashcard = FlashcardModel(
          id: testFlashcardId,
          deckId: testDeckId,
          front: newFront,
          back: newBack,
          isAiGenerated: false,
          wasModifiedByUser: true,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final mockFlashcards = [updatedFlashcard];

        when(
          () => mockRepository.updateFlashcard(
            flashcardId: testFlashcardId,
            newFront: newFront,
            newBack: newBack,
            wasModifiedByUser: true,
          ),
        ).thenAnswer((_) async => Right(updatedFlashcard));

        when(() => mockRepository.getFlashcardsForDeck(deckId: testDeckId))
            .thenAnswer((_) async => Right(mockFlashcards));
        when(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 1))
            .thenReturn(null);

        final expected = [
          const FlashcardState.loading(),
          FlashcardState.loaded(flashcards: mockFlashcards),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.updateFlashcard(
          deckId: testDeckId,
          flashcardId: testFlashcardId,
          newFront: newFront,
          newBack: newBack,
        );
      });

      test('should emit [loading, error] when updateFlashcard fails', () async {
        const failure = Failure.serverFailure(message: 'Flashcard not found');

        when(
          () => mockRepository.updateFlashcard(
            flashcardId: testFlashcardId,
            newFront: newFront,
            newBack: newBack,
            wasModifiedByUser: true,
          ),
        ).thenAnswer((_) async => const Left(failure));

        final expected = [
          const FlashcardState.loading(),
          const FlashcardState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.updateFlashcard(
          deckId: testDeckId,
          flashcardId: testFlashcardId,
          newFront: newFront,
          newBack: newBack,
        );
      });
    });

    group('deleteFlashcard', () {
      const testDeckId = 1;
      const testFlashcardId = 1;

      test('should emit [loading, loaded] when deleteFlashcard succeeds',
          () async {
        when(() => mockRepository.deleteFlashcard(flashcardId: testFlashcardId))
            .thenAnswer((_) async => const Right(null));

        when(() => mockRepository.getFlashcardsForDeck(deckId: testDeckId))
            .thenAnswer((_) async => const Right([]));
        when(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 0))
            .thenReturn(null);

        final expected = [
          const FlashcardState.loading(),
          const FlashcardState.loaded(flashcards: []),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.deleteFlashcard(testDeckId, testFlashcardId);
      });

      test('should emit [loading, error] when deleteFlashcard fails', () async {
        const failure = Failure.serverFailure(message: 'Failed to delete');

        when(() => mockRepository.deleteFlashcard(flashcardId: testFlashcardId))
            .thenAnswer((_) async => const Left(failure));

        final expected = [
          const FlashcardState.loading(),
          const FlashcardState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.deleteFlashcard(testDeckId, testFlashcardId);
      });
    });

    group('Edge Cases', () {
      group('TC-FLASHCARD-EDGE-001: Create flashcard with empty front/back',
          () {
        test('should handle empty front text', () async {
          const testDeckId = 1;
          const failure = Failure.serverFailure(message: 'Front cannot be empty');

          when(
            () => mockRepository.createFlashcard(
              deckId: testDeckId,
              front: '',
              back: 'Back',
              isAiGenerated: false,
            ),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const FlashcardState.loading(),
            const FlashcardState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.createFlashcard(
            deckId: testDeckId,
            front: '',
            back: 'Back',
          );
        });

        test('should handle empty back text', () async {
          const testDeckId = 1;
          const failure = Failure.serverFailure(message: 'Back cannot be empty');

          when(
            () => mockRepository.createFlashcard(
              deckId: testDeckId,
              front: 'Front',
              back: '',
              isAiGenerated: false,
            ),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const FlashcardState.loading(),
            const FlashcardState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.createFlashcard(
            deckId: testDeckId,
            front: 'Front',
            back: '',
          );
        });
      });

      group('TC-FLASHCARD-EDGE-002: Create flashcard with whitespace-only',
          () {
        test('should handle whitespace-only front', () async {
          const testDeckId = 1;
          const failure = Failure.serverFailure(message: 'Invalid front');

          when(
            () => mockRepository.createFlashcard(
              deckId: testDeckId,
              front: '     ',
              back: 'Back',
              isAiGenerated: false,
            ),
          ).thenAnswer((_) async => const Left(failure));

          final expected = [
            const FlashcardState.loading(),
            const FlashcardState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.createFlashcard(
            deckId: testDeckId,
            front: '     ',
            back: 'Back',
          );
        });
      });

      group('TC-FLASHCARD-EDGE-011: Create flashcards with very long text',
          () {
        test('should handle very long text', () async {
          const testDeckId = 1;
          final longText = 'A' * 10000;
          final mockFlashcards = [mockFlashcard];

          when(
            () => mockRepository.createFlashcard(
              deckId: testDeckId,
              front: longText,
              back: longText,
              isAiGenerated: false,
            ),
          ).thenAnswer((_) async => Right(mockFlashcard));

          when(() => mockRepository.getFlashcardsForDeck(deckId: testDeckId))
              .thenAnswer((_) async => Right(mockFlashcards));
          when(() => mockDecksCubit.updateDeckFlashcardCount(testDeckId, 1))
              .thenReturn(null);

          final expected = [
            const FlashcardState.loading(),
            FlashcardState.loaded(flashcards: mockFlashcards),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.createFlashcard(
            deckId: testDeckId,
            front: longText,
            back: longText,
          );
        });
      });
    });
  });
}

