import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';
import 'package:x10devs/features/flashcard/data/repositories/ai_generation_repository_impl.dart';
import 'package:x10devs/features/flashcard/domain/data_sources/ai_generation_remote_data_source.dart';

class MockAIGenerationRemoteDataSource extends Mock
    implements IAIGenerationRemoteDataSource {}

void main() {
  late AIGenerationRepositoryImpl repository;
  late MockAIGenerationRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAIGenerationRemoteDataSource();
    repository = AIGenerationRepositoryImpl(mockDataSource);
  });

  group('AIGenerationRepositoryImpl', () {
    group('generateFlashcardsFromText', () {
      const testText = 'Test text for AI generation';

      test(
        'should return Right(List<FlashcardCandidateModel>) when successful',
        () async {
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

          when(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).thenAnswer((_) async => mockCandidates);

          final result = await repository.generateFlashcardsFromText(
            text: testText,
          );

          expect(result, isA<Right<Failure, List<FlashcardCandidateModel>>>());
          result.fold((failure) => fail('Should not return failure'), (
            candidates,
          ) {
            expect(candidates, equals(mockCandidates));
            expect(candidates.length, equals(2));
          });
          verify(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).called(1);
        },
      );

      test(
        'should return Right(empty list) when AI generates no flashcards',
        () async {
          when(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).thenAnswer((_) async => []);

          final result = await repository.generateFlashcardsFromText(
            text: testText,
          );

          expect(result, isA<Right<Failure, List<FlashcardCandidateModel>>>());
          result.fold(
            (failure) => fail('Should not return failure'),
            (candidates) => expect(candidates, isEmpty),
          );
        },
      );

      test(
        'should return Left(AIGenerationFailure) when DioException is thrown',
        () async {
          const errorMessage = 'Network error';

          when(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/api/generate'),
              message: errorMessage,
            ),
          );

          final result = await repository.generateFlashcardsFromText(
            text: testText,
          );

          expect(result, isA<Left<Failure, List<FlashcardCandidateModel>>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) =>
                  expect(message, equals(errorMessage)),
            );
          }, (candidates) => fail('Should not return candidates'));
        },
      );

      test(
        'should return Left(AIGenerationFailure) with default message when DioException has no message',
        () async {
          when(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).thenThrow(
            DioException(requestOptions: RequestOptions(path: '/api/generate')),
          );

          final result = await repository.generateFlashcardsFromText(
            text: testText,
          );

          expect(result, isA<Left<Failure, List<FlashcardCandidateModel>>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) =>
                  expect(message, equals('AI Generation Failed')),
            );
          }, (candidates) => fail('Should not return candidates'));
        },
      );

      test(
        'should return Left(Failure) when generic exception is thrown',
        () async {
          const errorMessage = 'Unexpected error';

          when(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).thenThrow(Exception(errorMessage));

          final result = await repository.generateFlashcardsFromText(
            text: testText,
          );

          expect(result, isA<Left<Failure, List<FlashcardCandidateModel>>>());
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
          }, (candidates) => fail('Should not return candidates'));
        },
      );
    });

    group('Edge Cases', () {
      group('TC-AI-EDGE-001: Generate flashcards with empty text', () {
        test('should handle empty text input', () async {
          const emptyText = '';

          when(
            () => mockDataSource.generateFlashcardsFromText(text: emptyText),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/api/generate'),
              message: 'Text cannot be empty',
            ),
          );

          final result = await repository.generateFlashcardsFromText(
            text: emptyText,
          );

          expect(result, isA<Left<Failure, List<FlashcardCandidateModel>>>());
          result.fold((f) {
            f.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) =>
                  expect(message, equals('Text cannot be empty')),
            );
          }, (candidates) => fail('Should not return candidates'));
        });
      });

      group('TC-AI-EDGE-002: Generate flashcards with very long text', () {
        test('should handle very long text input', () async {
          final longText = 'A' * 100000;
          final mockCandidates = [
            const FlashcardCandidateModel(front: 'Question', back: 'Answer'),
          ];

          when(
            () => mockDataSource.generateFlashcardsFromText(text: longText),
          ).thenAnswer((_) async => mockCandidates);

          final result = await repository.generateFlashcardsFromText(
            text: longText,
          );

          expect(result, isA<Right<Failure, List<FlashcardCandidateModel>>>());
          result.fold(
            (failure) => fail('Should not return failure'),
            (candidates) => expect(candidates, equals(mockCandidates)),
          );
        });
      });

      group('TC-AI-EDGE-003: Handle AI timeout', () {
        test(
          'should map timeout DioException to AIGenerationFailure',
          () async {
            const testText = 'Test text';

            when(
              () => mockDataSource.generateFlashcardsFromText(text: testText),
            ).thenThrow(
              DioException(
                requestOptions: RequestOptions(path: '/api/generate'),
                type: DioExceptionType.connectionTimeout,
                message: 'Connection timeout',
              ),
            );

            final result = await repository.generateFlashcardsFromText(
              text: testText,
            );

            expect(result, isA<Left<Failure, List<FlashcardCandidateModel>>>());
            result.fold((failure) {
              failure.when(
                failure: (message) => fail('Wrong failure type'),
                serverFailure: (message) => fail('Wrong failure type'),
                authFailure: (message) => fail('Wrong failure type'),
                invalidCredentialsFailure: (message) =>
                    fail('Wrong failure type'),
                emailInUseFailure: (message) => fail('Wrong failure type'),
                sessionExpiredFailure: (message) => fail('Wrong failure type'),
                aigenerationFailure: (message) =>
                    expect(message, contains('timeout')),
              );
            }, (candidates) => fail('Should not return candidates'));
          },
        );
      });

      group('TC-AI-EDGE-004: Handle invalid API response', () {
        test('should handle malformed AI response', () async {
          const testText = 'Test text';
          const errorMessage = 'Invalid response format';

          when(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).thenThrow(Exception(errorMessage));

          final result = await repository.generateFlashcardsFromText(
            text: testText,
          );

          expect(result, isA<Left<Failure, List<FlashcardCandidateModel>>>());
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
          }, (candidates) => fail('Should not return candidates'));
        });
      });

      group('TC-AI-EDGE-005: Handle rate limiting', () {
        test('should handle 429 rate limit error', () async {
          const testText = 'Test text';

          when(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/api/generate'),
              response: Response(
                requestOptions: RequestOptions(path: '/api/generate'),
                statusCode: 429,
              ),
              message: 'Rate limit exceeded',
            ),
          );

          final result = await repository.generateFlashcardsFromText(
            text: testText,
          );

          expect(result, isA<Left<Failure, List<FlashcardCandidateModel>>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) =>
                  expect(message, contains('Rate limit')),
            );
          }, (candidates) => fail('Should not return candidates'));
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

          when(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).thenAnswer((_) async => manyCandidates);

          final result = await repository.generateFlashcardsFromText(
            text: testText,
          );

          expect(result, isA<Right<Failure, List<FlashcardCandidateModel>>>());
          result.fold((failure) => fail('Should not return failure'), (
            candidates,
          ) {
            expect(candidates.length, equals(100));
            expect(candidates, equals(manyCandidates));
          });
        });
      });

      group('TC-AI-EDGE-007: Handle network errors', () {
        test('should handle connection error', () async {
          const testText = 'Test text';

          when(
            () => mockDataSource.generateFlashcardsFromText(text: testText),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/api/generate'),
              type: DioExceptionType.connectionError,
              message: 'No internet connection',
            ),
          );

          final result = await repository.generateFlashcardsFromText(
            text: testText,
          );

          expect(result, isA<Left<Failure, List<FlashcardCandidateModel>>>());
          result.fold((failure) {
            failure.when(
              failure: (message) => fail('Wrong failure type'),
              serverFailure: (message) => fail('Wrong failure type'),
              authFailure: (message) => fail('Wrong failure type'),
              invalidCredentialsFailure: (message) =>
                  fail('Wrong failure type'),
              emailInUseFailure: (message) => fail('Wrong failure type'),
              sessionExpiredFailure: (message) => fail('Wrong failure type'),
              aigenerationFailure: (message) =>
                  expect(message, contains('connection')),
            );
          }, (candidates) => fail('Should not return candidates'));
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

          when(
            () => mockDataSource.generateFlashcardsFromText(text: specialText),
          ).thenAnswer((_) async => mockCandidates);

          final result = await repository.generateFlashcardsFromText(
            text: specialText,
          );

          expect(result, isA<Right<Failure, List<FlashcardCandidateModel>>>());
          result.fold(
            (failure) => fail('Should not return failure'),
            (candidates) => expect(candidates, equals(mockCandidates)),
          );
        });
      });
    });
  });
}
