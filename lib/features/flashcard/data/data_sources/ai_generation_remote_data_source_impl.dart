import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:x10devs/core/errors/openrouter_exception.dart';
import '../../domain/data_sources/ai_generation_remote_data_source.dart';
import '../models/flashcard_candidate_model.dart';

@LazySingleton(as: IAIGenerationRemoteDataSource)
class AIGenerationRemoteDataSourceImpl
    implements IAIGenerationRemoteDataSource {
  AIGenerationRemoteDataSourceImpl({
    required Dio dio,
    @Named('openRouterApiKey') required String apiKey,
    @Named('openRouterBaseUrl') String baseUrl = 'https://openrouter.ai/api/v1',
  }) : _dio = dio,
       _apiKey = apiKey,
       _baseUrl = baseUrl {
    if (_apiKey.isEmpty) {
      throw OpenRouterException(
        message: 'OpenRouter API key is not configured',
        type: OpenRouterErrorType.authentication,
      );
    }
  }

  final Dio _dio;
  final String _apiKey;
  final String _baseUrl;
  final Map<String, List<FlashcardCandidateModel>> _cache = {};

  static const String _chatCompletionsEndpoint = '/chat/completions';
  static const String _defaultModel = 'openai/gpt-4o-mini';
  static const String _systemMessage = '''
You are an expert flashcard creator. Your task is to generate high-quality flashcards from the provided text.

Rules:
1. Create concise, clear questions for the front of the card
2. Provide accurate, complete answers for the back of the card
3. Focus on key concepts, definitions, and important facts
4. Each flashcard should test one specific piece of knowledge
5. Use simple, direct language
6. Generate between 3-10 flashcards depending on text length and complexity
''';

  @override
  Future<List<FlashcardCandidateModel>> generateFlashcardsFromText({
    required String text,
  }) async {
    _validateInput(text);
    final cacheKey = _generateCacheKey(text);
    if (_cache.containsKey(cacheKey)) {
      debugPrint(
        'OpenRouter: Returning cached result for text (${text.length} chars)',
      );
      return _cache[cacheKey]!;
    }
    final startTime = DateTime.now();
    try {
      debugPrint(
        'OpenRouter: Starting flashcard generation (text length: ${text.length})',
      );
      final payload = _buildRequestPayload(userMessage: text);
      final response = await _dio.post(
        '$_baseUrl$_chatCompletionsEndpoint',
        data: payload,
        options: Options(headers: _buildHeaders()),
      );
      final flashcards = _parseResponse(response.data);
      if (flashcards.isEmpty) {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          message:
              'No flashcards were generated. Please try with different text.',
        );
      }
      _cache[cacheKey] = flashcards;
      if (_cache.length > 50) {
        final firstKey = _cache.keys.first;
        _cache.remove(firstKey);
      }
      final duration = DateTime.now().difference(startTime);
      debugPrint(
        'OpenRouter: Generated ${flashcards.length} flashcards in ${duration.inMilliseconds}ms',
      );
      return flashcards;
    } on OpenRouterException catch (e) {
      final duration = DateTime.now().difference(startTime);
      debugPrint(
        'OpenRouter: Failed after ${duration.inMilliseconds}ms - ${e.type}: ${e.message}',
      );
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: e.message,
      );
    } on DioException catch (e) {
      final duration = DateTime.now().difference(startTime);
      debugPrint(
        'OpenRouter: Network error after ${duration.inMilliseconds}ms - ${e.message}',
      );
      throw _handleDioException(e);
    } on FormatException catch (e) {
      final duration = DateTime.now().difference(startTime);
      debugPrint(
        'OpenRouter: Parse error after ${duration.inMilliseconds}ms - ${e.message}',
      );
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'Failed to parse AI response: ${e.message}',
      );
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      debugPrint(
        'OpenRouter: Unexpected error after ${duration.inMilliseconds}ms - $e',
      );
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'Unexpected error: $e',
      );
    }
  }

  void _validateInput(String text) {
    if (text.trim().isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'Text cannot be empty',
      );
    }
    if (text.length > 10000) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'Text is too long. Maximum 10,000 characters allowed.',
      );
    }
  }

  String _generateCacheKey(String text) {
    return text.trim().toLowerCase();
  }

  Map<String, dynamic> _buildRequestPayload({required String userMessage}) {
    return {
      'model': _defaultModel,
      'messages': [
        {'role': 'system', 'content': _systemMessage},
        {'role': 'user', 'content': userMessage},
      ],
      'response_format': {
        'type': 'json_schema',
        'json_schema': {
          'name': 'flashcard_generation_response',
          'strict': true,
          'schema': {
            'type': 'object',
            'properties': {
              'flashcards': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'properties': {
                    'front': {'type': 'string'},
                    'back': {'type': 'string'},
                  },
                  'required': ['front', 'back'],
                  'additionalProperties': false,
                },
              },
            },
            'required': ['flashcards'],
            'additionalProperties': false,
          },
        },
      },
      'temperature': 0.7,
      'max_tokens': 2000,
      'top_p': 1.0,
    };
  }

  List<FlashcardCandidateModel> _parseResponse(
    Map<String, dynamic> responseData,
  ) {
    try {
      final content =
          responseData['choices'][0]['message']['content'] as String;
      final jsonContent = jsonDecode(content) as Map<String, dynamic>;
      final flashcardsJson = jsonContent['flashcards'] as List<dynamic>;
      return flashcardsJson
          .map(
            (item) =>
                FlashcardCandidateModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw FormatException('Invalid response structure: $e');
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Authorization': 'Bearer $_apiKey',
      'HTTP-Referer': 'https://x10devs.app',
      'X-Title': 'X10Devs Flashcard App',
      'Content-Type': 'application/json',
    };
  }

  DioException _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return DioException(
        requestOptions: e.requestOptions,
        message: 'Connection timeout. Please check your internet connection.',
      );
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      return DioException(
        requestOptions: e.requestOptions,
        message: 'Request took too long. Please try again.',
      );
    }
    if (e.type == DioExceptionType.connectionError) {
      return DioException(
        requestOptions: e.requestOptions,
        message: 'Unable to connect to AI service. Please check your internet.',
      );
    }
    final statusCode = e.response?.statusCode;
    final errorMessage =
        e.response?.data?['error']?['message'] ?? 'Unknown error';
    switch (statusCode) {
      case 401:
        return DioException(
          requestOptions: e.requestOptions,
          message: 'Invalid API key. Please check your configuration.',
        );
      case 429:
        return DioException(
          requestOptions: e.requestOptions,
          message: 'Rate limit exceeded. Please try again later.',
        );
      case 400:
        return DioException(
          requestOptions: e.requestOptions,
          message: 'Invalid request: $errorMessage',
        );
      case 404:
        return DioException(
          requestOptions: e.requestOptions,
          message: 'Model not found. Please check model configuration.',
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return DioException(
            requestOptions: e.requestOptions,
            message: 'AI service is temporarily unavailable. Please try again.',
          );
        }
        return DioException(
          requestOptions: e.requestOptions,
          message: 'Request failed: $errorMessage',
        );
    }
  }
}
