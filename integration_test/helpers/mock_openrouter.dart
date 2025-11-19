import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of Dio for OpenRouter API
class MockDio extends Mock implements Dio {}

/// Helper class to setup OpenRouter API mocks
class MockOpenRouter {
  /// Creates a mock Dio instance with predefined responses
  static Dio createMockDio() {
    final mockDio = MockDio();

    // Setup fallback values for mocktail
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Options());

    // Mock successful flashcard generation
    when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Return mock flashcards
      return Response(
        data: {
          'choices': [
            {
              'message': {
                'content': jsonEncode({
                  'flashcards': [
                    {
                      'front': 'What is Flutter?',
                      'back':
                          'Flutter is an open-source UI software development kit created by Google.',
                    },
                    {
                      'front': 'What is Dart?',
                      'back':
                          'Dart is a programming language optimized for building mobile, desktop, server, and web applications.',
                    },
                    {
                      'front': 'What is a Widget in Flutter?',
                      'back':
                          'A Widget is the basic building block of a Flutter app\'s user interface.',
                    },
                  ]
                })
              }
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      );
    });

    return mockDio;
  }

  /// Creates a mock Dio that simulates API error
  static Dio createMockDioWithError({
    int statusCode = 500,
    String message = 'Internal Server Error',
  }) {
    final mockDio = MockDio();

    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Options());

    when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenThrow(DioException(
      requestOptions: RequestOptions(path: ''),
      response: Response(
        statusCode: statusCode,
        data: {'error': {'message': message}},
        requestOptions: RequestOptions(path: ''),
      ),
    ));

    return mockDio;
  }

  /// Creates a mock Dio that simulates timeout
  static Dio createMockDioWithTimeout() {
    final mockDio = MockDio();

    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Options());

    when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenThrow(DioException(
      requestOptions: RequestOptions(path: ''),
      type: DioExceptionType.receiveTimeout,
      message: 'Request timeout',
    ));

    return mockDio;
  }

  /// Creates a mock Dio that simulates rate limit error
  static Dio createMockDioWithRateLimit() {
    return createMockDioWithError(
      statusCode: 429,
      message: 'Rate limit exceeded',
    );
  }

  /// Creates a mock Dio that returns custom flashcards
  static Dio createMockDioWithCustomFlashcards(
    List<Map<String, String>> flashcards,
  ) {
    final mockDio = MockDio();

    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Options());

    when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 500));

      return Response(
        data: {
          'choices': [
            {
              'message': {'content': jsonEncode({'flashcards': flashcards})}
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      );
    });

    return mockDio;
  }
}

