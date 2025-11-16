import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';
import 'package:x10devs/features/flashcard/domain/repositories/ai_generation_repository.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_state.dart';

class MockAIGenerationRepository extends Mock
    implements IAIGenerationRepository {}

void main() {
  late AiGenerationCubit cubit;
  late MockAIGenerationRepository mockRepository;

  setUp(() {
    mockRepository = MockAIGenerationRepository();
    cubit = AiGenerationCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('AiGenerationCubit', () {
    group('initial state', () {
      test('should have initial state', () {
        expect(cubit.state, equals(const AiGenerationState.initial()));
      });
    });

    group('generateFlashcards', () {
      const testText = 'Test text for AI generation';

      test('should emit [loading, loaded] when generation succeeds', () async {
        final mockCandidates = [
          const FlashcardCandidateModel(
            front: 'Question 1',
            back: 'Answer 1',
          ),
          const FlashcardCandidateModel(
            front: 'Question 2',
            back: 'Answer 2',
          ),
        ];

        when(() => mockRepository.generateFlashcardsFromText(text: testText))
            .thenAnswer((_) async => Right(mockCandidates));

        final expected = [
          const AiGenerationState.loading(),
          AiGenerationState.loaded(candidates: mockCandidates),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.generateFlashcards(testText);

        verify(() => mockRepository.generateFlashcardsFromText(text: testText))
            .called(1);
      });

      test('should emit [loading, loaded] with empty list when AI generates no flashcards',
          () async {
        when(() => mockRepository.generateFlashcardsFromText(text: testText))
            .thenAnswer((_) async => const Right([]));

        final expected = [
          const AiGenerationState.loading(),
          const AiGenerationState.loaded(candidates: []),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.generateFlashcards(testText);
      });

      test('should emit [loading, error] when generation fails', () async {
        const failure = Failure.aigenerationFailure(message: 'AI error');

        when(() => mockRepository.generateFlashcardsFromText(text: testText))
            .thenAnswer((_) async => const Left(failure));

        final expected = [
          const AiGenerationState.loading(),
          const AiGenerationState.error(failure: failure),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.generateFlashcards(testText);
      });

      test('should call repository with correct text parameter', () async {
        const customText = 'Custom test text';
        final mockCandidates = [
          const FlashcardCandidateModel(front: 'Q', back: 'A'),
        ];

        when(() => mockRepository.generateFlashcardsFromText(text: customText))
            .thenAnswer((_) async => Right(mockCandidates));

        await cubit.generateFlashcards(customText);

        verify(() => mockRepository.generateFlashcardsFromText(text: customText))
            .called(1);
      });
    });

    group('Edge Cases', () {
      group('TC-AI-EDGE-001: Generate flashcards with empty text', () {
        test('should handle empty text', () async {
          const emptyText = '';
          const failure = Failure.aigenerationFailure(
            message: 'Text cannot be empty',
          );

          when(() => mockRepository.generateFlashcardsFromText(text: emptyText))
              .thenAnswer((_) async => const Left(failure));

          final expected = [
            const AiGenerationState.loading(),
            const AiGenerationState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.generateFlashcards(emptyText);
        });
      });

      group('TC-AI-EDGE-002: Generate flashcards with very long text', () {
        test('should handle very long text', () async {
          final longText = 'A' * 100000;
          final mockCandidates = [
            const FlashcardCandidateModel(
              front: 'Question from long text',
              back: 'Answer from long text',
            ),
          ];

          when(() => mockRepository.generateFlashcardsFromText(text: longText))
              .thenAnswer((_) async => Right(mockCandidates));

          final expected = [
            const AiGenerationState.loading(),
            AiGenerationState.loaded(candidates: mockCandidates),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.generateFlashcards(longText);
        });
      });

      group('TC-AI-EDGE-003: Handle AI timeout', () {
        test('should emit error when AI times out', () async {
          const testText = 'Test text';
          const failure = Failure.aigenerationFailure(
            message: 'Connection timeout',
          );

          when(() => mockRepository.generateFlashcardsFromText(text: testText))
              .thenAnswer((_) async => const Left(failure));

          final expected = [
            const AiGenerationState.loading(),
            const AiGenerationState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.generateFlashcards(testText);
        });
      });

      group('TC-AI-EDGE-004: Handle invalid API response', () {
        test('should emit error when API response is invalid', () async {
          const testText = 'Test text';
          const failure = Failure.failure(
            message: 'Invalid response format',
          );

          when(() => mockRepository.generateFlashcardsFromText(text: testText))
              .thenAnswer((_) async => const Left(failure));

          final expected = [
            const AiGenerationState.loading(),
            const AiGenerationState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.generateFlashcards(testText);
        });
      });

      group('TC-AI-EDGE-005: Handle rate limiting', () {
        test('should emit error when rate limit is exceeded', () async {
          const testText = 'Test text';
          const failure = Failure.aigenerationFailure(
            message: 'Rate limit exceeded',
          );

          when(() => mockRepository.generateFlashcardsFromText(text: testText))
              .thenAnswer((_) async => const Left(failure));

          final expected = [
            const AiGenerationState.loading(),
            const AiGenerationState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.generateFlashcards(testText);
        });
      });

      group('TC-AI-EDGE-006: Generate large number of flashcards', () {
        test('should handle AI generating many flashcards', () async {
          const testText = 'Very detailed text for many flashcards';
          final manyCandidates = List.generate(
            100,
            (index) => FlashcardCandidateModel(
              front: 'Question $index',
              back: 'Answer $index',
            ),
          );

          when(() => mockRepository.generateFlashcardsFromText(text: testText))
              .thenAnswer((_) async => Right(manyCandidates));

          final expected = [
            const AiGenerationState.loading(),
            AiGenerationState.loaded(candidates: manyCandidates),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.generateFlashcards(testText);

          cubit.state.maybeMap(
            loaded: (state) => expect(state.candidates.length, equals(100)),
            orElse: () => fail('State should be loaded'),
          );
        });
      });

      group('TC-AI-EDGE-007: Handle network errors', () {
        test('should emit error when network connection fails', () async {
          const testText = 'Test text';
          const failure = Failure.aigenerationFailure(
            message: 'No internet connection',
          );

          when(() => mockRepository.generateFlashcardsFromText(text: testText))
              .thenAnswer((_) async => const Left(failure));

          final expected = [
            const AiGenerationState.loading(),
            const AiGenerationState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.generateFlashcards(testText);
        });
      });

      group('TC-AI-EDGE-008: Handle special characters in text', () {
        test('should handle text with special characters', () async {
          const specialText = 'Test with émojis 🎉 and spëcial çhars!';
          final mockCandidates = [
            const FlashcardCandidateModel(
              front: 'Question with émojis 🎉',
              back: 'Answer with spëcial çhars',
            ),
          ];

          when(() => mockRepository.generateFlashcardsFromText(text: specialText))
              .thenAnswer((_) async => Right(mockCandidates));

          final expected = [
            const AiGenerationState.loading(),
            AiGenerationState.loaded(candidates: mockCandidates),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.generateFlashcards(specialText);
        });
      });

      group('TC-AI-EDGE-009: Multiple consecutive generations', () {
        test('should handle multiple consecutive generation requests', () async {
          const text1 = 'First text';
          const text2 = 'Second text';

          final candidates1 = [
            const FlashcardCandidateModel(front: 'Q1', back: 'A1'),
          ];
          final candidates2 = [
            const FlashcardCandidateModel(front: 'Q2', back: 'A2'),
          ];

          when(() => mockRepository.generateFlashcardsFromText(text: text1))
              .thenAnswer((_) async => Right(candidates1));
          when(() => mockRepository.generateFlashcardsFromText(text: text2))
              .thenAnswer((_) async => Right(candidates2));

          await cubit.generateFlashcards(text1);
          expect(
            cubit.state,
            equals(AiGenerationState.loaded(candidates: candidates1)),
          );

          await cubit.generateFlashcards(text2);
          expect(
            cubit.state,
            equals(AiGenerationState.loaded(candidates: candidates2)),
          );

          verify(() => mockRepository.generateFlashcardsFromText(text: text1))
              .called(1);
          verify(() => mockRepository.generateFlashcardsFromText(text: text2))
              .called(1);
        });
      });

      group('TC-AI-EDGE-010: Whitespace-only text', () {
        test('should handle whitespace-only text', () async {
          const whitespaceText = '     ';
          const failure = Failure.aigenerationFailure(
            message: 'Text cannot be empty',
          );

          when(() => mockRepository.generateFlashcardsFromText(text: whitespaceText))
              .thenAnswer((_) async => const Left(failure));

          final expected = [
            const AiGenerationState.loading(),
            const AiGenerationState.error(failure: failure),
          ];

          expectLater(cubit.stream, emitsInOrder(expected));

          await cubit.generateFlashcards(whitespaceText);
        });
      });
    });
  });
}

