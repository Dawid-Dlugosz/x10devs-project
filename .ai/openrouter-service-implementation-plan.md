# OpenRouter Service Implementation Plan

## 1. Service Overview

The OpenRouter service is responsible for integrating with the OpenRouter API to provide LLM-based chat completions for flashcard generation. This service will handle communication with various AI models through a unified interface, supporting structured JSON responses, custom system/user messages, and configurable model parameters.

### Key Responsibilities
- Construct and send properly formatted API requests to OpenRouter
- Handle structured JSON responses using `response_format`
- Manage API authentication and security
- Parse and validate AI-generated flashcard candidates
- Provide comprehensive error handling for network and API failures

### Integration Points
- Used by `AIGenerationRemoteDataSourceImpl`
- Configured via environment variables (`.env` file)
- Registered in dependency injection container via `injectable`

---

## 2. Constructor Description

### Purpose
Initialize the OpenRouter service with necessary dependencies and configuration.

### Parameters
- `Dio dio`: HTTP client for making API requests (injected via `injectable`)
- `String apiKey`: OpenRouter API key (loaded from environment variables)
- `String baseUrl`: OpenRouter API base URL (default: `https://openrouter.ai/api/v1`)

### Configuration Requirements
The constructor should:
1. Accept a pre-configured `Dio` instance with interceptors
2. Validate that the API key is not empty
3. Set up default headers for all requests (Authorization, HTTP-Referer, X-Title)
4. Configure timeout settings (connect: 30s, receive: 60s)


## 3. Public Methods and Fields

### 3.1 Primary Method: `generateFlashcards`

#### Signature
```dart
Future<List<FlashcardCandidateModel>> generateFlashcards({
  required String text,
  String? modelName,
  Map<String, dynamic>? modelParameters,
})
```

#### Parameters
- `text` (required): Source text from which to generate flashcards
- `modelName` (optional): Specific model to use (default: configured in service)
- `modelParameters` (optional): Additional model parameters (temperature, max_tokens, etc.)

#### Return Value
Returns a `Future<List<FlashcardCandidateModel>>` containing generated flashcard candidates.

#### Throws
- `DioException`: For network-related errors
- `FormatException`: For JSON parsing errors
- `OpenRouterException`: Custom exception for API-specific errors

#### Functionality
1. Constructs the complete API request payload
2. Sends POST request to `/chat/completions` endpoint
3. Validates the response structure
4. Parses JSON response into `FlashcardCandidateModel` objects
5. Returns the list of candidates

---

### 3.2 Public Fields

```dart
// Default model to use for flashcard generation
static const String defaultModel = 'google/gemini-2.0-flash-exp:free';

// Default system message for flashcard generation
static const String defaultSystemMessage = '''
You are an expert flashcard creator. Your task is to generate high-quality flashcards from the provided text.

Rules:
1. Create concise, clear questions for the front of the card
2. Provide accurate, complete answers for the back of the card
3. Focus on key concepts, definitions, and important facts
4. Each flashcard should test one specific piece of knowledge
5. Use simple, direct language
6. Generate between 3-10 flashcards depending on text length and complexity

Return ONLY a JSON array of flashcards with this exact structure:
{
  "flashcards": [
    {"front": "question or prompt", "back": "answer or explanation"}
  ]
}
''';
```

---

## 4. Private Methods and Fields

### 4.1 `_buildRequestPayload`

#### Signature
```dart
Map<String, dynamic> _buildRequestPayload({
  required String userMessage,
  String? modelName,
  Map<String, dynamic>? modelParameters,
})
```

#### Purpose
Constructs the complete request payload for the OpenRouter API.

#### Implementation Details
```dart
{
  "model": modelName ?? defaultModel,
  "messages": [
    {
      "role": "system",
      "content": defaultSystemMessage
    },
    {
      "role": "user",
      "content": userMessage
    }
  ],
  "response_format": {
    "type": "json_schema",
    "json_schema": {
      "name": "flashcard_generation_response",
      "strict": true,
      "schema": {
        "type": "object",
        "properties": {
          "flashcards": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "front": {"type": "string"},
                "back": {"type": "string"}
              },
              "required": ["front", "back"],
              "additionalProperties": false
            }
          }
        },
        "required": ["flashcards"],
        "additionalProperties": false
      }
    }
  },
  "temperature": modelParameters?['temperature'] ?? 0.7,
  "max_tokens": modelParameters?['max_tokens'] ?? 2000,
  "top_p": modelParameters?['top_p'] ?? 1.0,
}
```

### 4.2 `_parseResponse`

#### Signature
```dart
List<FlashcardCandidateModel> _parseResponse(Map<String, dynamic> responseData)
```

#### Purpose
Extracts and parses flashcard candidates from the API response.

#### Implementation Logic
1. Navigate to `choices[0].message.content`
2. Parse the content as JSON
3. Extract the `flashcards` array
4. Map each item to `FlashcardCandidateModel`
5. Validate that at least one flashcard was generated
6. Return the list of candidates

#### Error Handling
- Throws `FormatException` if JSON structure is invalid
- Throws `OpenRouterException` if no flashcards were generated
- Logs warnings for malformed individual flashcards but continues processing

### 4.3 `_buildHeaders`

#### Signature
```dart
Map<String, String> _buildHeaders()
```

#### Purpose
Constructs the required headers for OpenRouter API requests.

#### Returns
```dart
{
  'Authorization': 'Bearer $apiKey',
  'HTTP-Referer': 'https://x10devs.app', // Your app URL
  'X-Title': 'X10Devs Flashcard App',
  'Content-Type': 'application/json',
}
```

### 4.4 Private Fields

```dart
final Dio _dio;
final String _apiKey;
final String _baseUrl;
static const String _chatCompletionsEndpoint = '/chat/completions';
```

---

## 5. Error Handling

### 5.1 Error Categories

#### 1. Network Errors
**Scenarios:**
- No internet connection
- Request timeout
- DNS resolution failure

**Handling Strategy:**
```dart
try {
  final response = await _dio.post(...);
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    throw OpenRouterException(
      message: 'Connection timeout. Please check your internet connection.',
      type: OpenRouterErrorType.timeout,
    );
  } else if (e.type == DioExceptionType.receiveTimeout) {
    throw OpenRouterException(
      message: 'Request took too long. Please try again.',
      type: OpenRouterErrorType.timeout,
    );
  } else if (e.type == DioExceptionType.connectionError) {
    throw OpenRouterException(
      message: 'Unable to connect to AI service. Please check your internet.',
      type: OpenRouterErrorType.network,
    );
  }
}
```

#### 2. API Errors
**Scenarios:**
- Invalid API key (401)
- Rate limit exceeded (429)
- Model not found (404)
- Invalid request format (400)
- Server errors (500-599)

**Handling Strategy:**
```dart
on DioException catch (e) {
  final statusCode = e.response?.statusCode;
  final errorMessage = e.response?.data['error']?['message'] ?? 'Unknown error';
  
  switch (statusCode) {
    case 401:
      throw OpenRouterException(
        message: 'Invalid API key. Please check your configuration.',
        type: OpenRouterErrorType.authentication,
      );
    case 429:
      throw OpenRouterException(
        message: 'Rate limit exceeded. Please try again later.',
        type: OpenRouterErrorType.rateLimit,
      );
    case 400:
      throw OpenRouterException(
        message: 'Invalid request: $errorMessage',
        type: OpenRouterErrorType.invalidRequest,
      );
    case 404:
      throw OpenRouterException(
        message: 'Model not found. Please check model configuration.',
        type: OpenRouterErrorType.modelNotFound,
      );
    default:
      if (statusCode != null && statusCode >= 500) {
        throw OpenRouterException(
          message: 'AI service is temporarily unavailable. Please try again.',
          type: OpenRouterErrorType.serverError,
        );
      }
  }
}
```

#### 3. Parsing Errors
**Scenarios:**
- Invalid JSON in response
- Missing required fields
- Unexpected response structure

**Handling Strategy:**
```dart
try {
  final flashcards = _parseResponse(response.data);
  return flashcards;
} on FormatException catch (e) {
  throw OpenRouterException(
    message: 'Failed to parse AI response: ${e.message}',
    type: OpenRouterErrorType.parsing,
  );
} catch (e) {
  throw OpenRouterException(
    message: 'Unexpected error processing AI response: $e',
    type: OpenRouterErrorType.unknown,
  );
}
```

#### 4. Validation Errors
**Scenarios:**
- Empty text input
- Text too long (exceeds model context window)
- No flashcards generated

**Handling Strategy:**
```dart
Future<List<FlashcardCandidateModel>> generateFlashcards({
  required String text,
  String? modelName,
  Map<String, dynamic>? modelParameters,
}) async {
  // Input validation
  if (text.trim().isEmpty) {
    throw OpenRouterException(
      message: 'Text cannot be empty',
      type: OpenRouterErrorType.validation,
    );
  }
  
  if (text.length > 10000) {
    throw OpenRouterException(
      message: 'Text is too long. Maximum 10,000 characters allowed.',
      type: OpenRouterErrorType.validation,
    );
  }
  
  // ... API call ...
  
  // Output validation
  if (flashcards.isEmpty) {
    throw OpenRouterException(
      message: 'No flashcards were generated. Please try with different text.',
      type: OpenRouterErrorType.noResults,
    );
  }
  
  return flashcards;
}
```

### 5.2 Custom Exception Class

```dart
enum OpenRouterErrorType {
  network,
  timeout,
  authentication,
  rateLimit,
  invalidRequest,
  modelNotFound,
  serverError,
  parsing,
  validation,
  noResults,
  unknown,
}

class OpenRouterException implements Exception {
  final String message;
  final OpenRouterErrorType type;
  final dynamic originalError;
  
  OpenRouterException({
    required this.message,
    required this.type,
    this.originalError,
  });
  
  @override
  String toString() => 'OpenRouterException: $message';
}
```

---

## 6. Security Considerations

### 6.1 API Key Management

**Best Practices:**
1. **Never hardcode API keys** in source code
2. Store API key in `.env` file (excluded from version control)
3. Load API key using `flutter_dotenv` package
4. Validate API key format on initialization

**Implementation:**
```dart
// In main.dart
await dotenv.load(fileName: '.env');

// In DI configuration
@module
abstract class OpenRouterModule {
  @Named('openRouterApiKey')
  String get apiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';
  
  @Named('openRouterBaseUrl')
  String get baseUrl => dotenv.env['OPENROUTER_BASE_URL'] ?? 
    'https://openrouter.ai/api/v1';
}
```

**`.env` file example:**
```
OPENROUTER_API_KEY=sk-or-v1-your-api-key-here
OPENROUTER_BASE_URL=https://openrouter.ai/api/v1
```

### 6.2 Request Security

**Headers:**
- Include `HTTP-Referer` header with your app's domain
- Include `X-Title` header with your app name
- These headers help OpenRouter track usage and provide analytics

**Rate Limiting:**
- Implement client-side rate limiting to prevent abuse
- Cache results when appropriate
- Show loading states to prevent multiple simultaneous requests

### 6.3 Data Privacy

**Considerations:**
1. User-provided text is sent to external AI service
2. Inform users about data processing in privacy policy
3. Consider implementing local caching to minimize API calls
4. Don't send sensitive personal information to AI service

### 6.4 Error Message Sanitization

**Best Practice:**
- Don't expose API keys or internal details in error messages
- Provide user-friendly error messages
- Log detailed errors server-side only

```dart
catch (e) {
  // Log full error for debugging
  debugPrint('OpenRouter error: $e');
  
  // Return sanitized message to user
  throw OpenRouterException(
    message: 'Failed to generate flashcards. Please try again.',
    type: OpenRouterErrorType.unknown,
  );
}
```

---

## 7. Step-by-Step Implementation Plan

### Step 1: Environment Configuration

**Files to create/modify:**
- `.env` (create if doesn't exist)
- `.gitignore` (ensure `.env` is excluded)

**Actions:**
1. Create `.env` file in project root:
```
OPENROUTER_API_KEY=your-api-key-here
OPENROUTER_BASE_URL=https://openrouter.ai/api/v1
```

2. Verify `.gitignore` includes:
```
.env
*.env
```

3. Update `main.dart` to load environment variables:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await configureDependencies();
  runApp(const MyApp());
}
```

---

### Step 2: Create Custom Exception Class

**File:** `lib/core/errors/openrouter_exception.dart`

**Content:**
```dart
enum OpenRouterErrorType {
  network,
  timeout,
  authentication,
  rateLimit,
  invalidRequest,
  modelNotFound,
  serverError,
  parsing,
  validation,
  noResults,
  unknown,
}

class OpenRouterException implements Exception {
  OpenRouterException({
    required this.message,
    required this.type,
    this.originalError,
  });

  final String message;
  final OpenRouterErrorType type;
  final dynamic originalError;

  @override
  String toString() => 'OpenRouterException($type): $message';
}
```

---

### Step 3: Create OpenRouter Service

**File:** `lib/core/services/openrouter_service.dart`

**Implementation:**

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:x10devs/core/errors/openrouter_exception.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';

@lazySingleton
class OpenRouterService {
  OpenRouterService({
    required Dio dio,
    @Named('openRouterApiKey') required String apiKey,
    @Named('openRouterBaseUrl') String baseUrl = 'https://openrouter.ai/api/v1',
  })  : _dio = dio,
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

  static const String _chatCompletionsEndpoint = '/chat/completions';
  static const String defaultModel = 'google/gemini-2.0-flash-exp:free';
  static const String defaultSystemMessage = '''
You are an expert flashcard creator. Your task is to generate high-quality flashcards from the provided text.

Rules:
1. Create concise, clear questions for the front of the card
2. Provide accurate, complete answers for the back of the card
3. Focus on key concepts, definitions, and important facts
4. Each flashcard should test one specific piece of knowledge
5. Use simple, direct language
6. Generate between 3-10 flashcards depending on text length and complexity

Return ONLY a JSON array of flashcards with this exact structure:
{
  "flashcards": [
    {"front": "question or prompt", "back": "answer or explanation"}
  ]
}
''';

  Future<List<FlashcardCandidateModel>> generateFlashcards({
    required String text,
    String? modelName,
    Map<String, dynamic>? modelParameters,
  }) async {
    _validateInput(text);

    try {
      final payload = _buildRequestPayload(
        userMessage: text,
        modelName: modelName,
        modelParameters: modelParameters,
      );

      final response = await _dio.post(
        '$_baseUrl$_chatCompletionsEndpoint',
        data: payload,
        options: Options(headers: _buildHeaders()),
      );

      final flashcards = _parseResponse(response.data);

      if (flashcards.isEmpty) {
        throw OpenRouterException(
          message: 'No flashcards were generated. Please try with different text.',
          type: OpenRouterErrorType.noResults,
        );
      }

      return flashcards;
    } on OpenRouterException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } on FormatException catch (e) {
      throw OpenRouterException(
        message: 'Failed to parse AI response: ${e.message}',
        type: OpenRouterErrorType.parsing,
        originalError: e,
      );
    } catch (e) {
      throw OpenRouterException(
        message: 'Unexpected error: $e',
        type: OpenRouterErrorType.unknown,
        originalError: e,
      );
    }
  }

  void _validateInput(String text) {
    if (text.trim().isEmpty) {
      throw OpenRouterException(
        message: 'Text cannot be empty',
        type: OpenRouterErrorType.validation,
      );
    }

    if (text.length > 10000) {
      throw OpenRouterException(
        message: 'Text is too long. Maximum 10,000 characters allowed.',
        type: OpenRouterErrorType.validation,
      );
    }
  }

  Map<String, dynamic> _buildRequestPayload({
    required String userMessage,
    String? modelName,
    Map<String, dynamic>? modelParameters,
  }) {
    return {
      'model': modelName ?? defaultModel,
      'messages': [
        {
          'role': 'system',
          'content': defaultSystemMessage,
        },
        {
          'role': 'user',
          'content': userMessage,
        },
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
      'temperature': modelParameters?['temperature'] ?? 0.7,
      'max_tokens': modelParameters?['max_tokens'] ?? 2000,
      'top_p': modelParameters?['top_p'] ?? 1.0,
    };
  }

  List<FlashcardCandidateModel> _parseResponse(Map<String, dynamic> responseData) {
    try {
      final content = responseData['choices'][0]['message']['content'] as String;
      final jsonContent = jsonDecode(content) as Map<String, dynamic>;
      final flashcardsJson = jsonContent['flashcards'] as List<dynamic>;

      return flashcardsJson
          .map((item) => FlashcardCandidateModel.fromJson(item as Map<String, dynamic>))
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

  OpenRouterException _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return OpenRouterException(
        message: 'Connection timeout. Please check your internet connection.',
        type: OpenRouterErrorType.timeout,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return OpenRouterException(
        message: 'Request took too long. Please try again.',
        type: OpenRouterErrorType.timeout,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return OpenRouterException(
        message: 'Unable to connect to AI service. Please check your internet.',
        type: OpenRouterErrorType.network,
        originalError: e,
      );
    }

    final statusCode = e.response?.statusCode;
    final errorMessage = e.response?.data?['error']?['message'] ?? 'Unknown error';

    switch (statusCode) {
      case 401:
        return OpenRouterException(
          message: 'Invalid API key. Please check your configuration.',
          type: OpenRouterErrorType.authentication,
          originalError: e,
        );
      case 429:
        return OpenRouterException(
          message: 'Rate limit exceeded. Please try again later.',
          type: OpenRouterErrorType.rateLimit,
          originalError: e,
        );
      case 400:
        return OpenRouterException(
          message: 'Invalid request: $errorMessage',
          type: OpenRouterErrorType.invalidRequest,
          originalError: e,
        );
      case 404:
        return OpenRouterException(
          message: 'Model not found. Please check model configuration.',
          type: OpenRouterErrorType.modelNotFound,
          originalError: e,
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return OpenRouterException(
            message: 'AI service is temporarily unavailable. Please try again.',
            type: OpenRouterErrorType.serverError,
            originalError: e,
          );
        }
        return OpenRouterException(
          message: 'Request failed: $errorMessage',
          type: OpenRouterErrorType.unknown,
          originalError: e,
        );
    }
  }
}
```

---

### Step 4: Configure Dependency Injection

**File:** `lib/core/di/openrouter_module.dart` (create new file)

**Content:**
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@module
abstract class OpenRouterModule {
  @Named('openRouterApiKey')
  String get apiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';

  @Named('openRouterBaseUrl')
  String get baseUrl =>
      dotenv.env['OPENROUTER_BASE_URL'] ?? 'https://openrouter.ai/api/v1';
}
```

---

### Step 5: Update AIGenerationRemoteDataSourceImpl

**File:** `lib/features/flashcard/data/data_sources/ai_generation_remote_data_source_impl.dart`

**Modifications:**

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:x10devs/core/errors/openrouter_exception.dart';
import 'package:x10devs/core/services/openrouter_service.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';
import 'package:x10devs/features/flashcard/domain/data_sources/ai_generation_remote_data_source.dart';

@LazySingleton(as: IAIGenerationRemoteDataSource)
class AIGenerationRemoteDataSourceImpl
    implements IAIGenerationRemoteDataSource {
  AIGenerationRemoteDataSourceImpl(this._openRouterService);

  final OpenRouterService _openRouterService;

  @override
  Future<List<FlashcardCandidateModel>> generateFlashcardsFromText({
    required String text,
  }) async {
    try {
      return await _openRouterService.generateFlashcards(text: text);
    } on OpenRouterException catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: e.message,
      );
    }
  }
}
```

---

### Step 6: Update AIGenerationRepositoryImpl Error Handling

**File:** `lib/features/flashcard/data/repositories/ai_generation_repository_impl.dart`

**Modifications:**

```dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';
import 'package:x10devs/features/flashcard/domain/data_sources/ai_generation_remote_data_source.dart';
import 'package:x10devs/features/flashcard/domain/repositories/ai_generation_repository.dart';

@LazySingleton(as: IAIGenerationRepository)
class AIGenerationRepositoryImpl implements IAIGenerationRepository {
  AIGenerationRepositoryImpl(this._aiGenerationRemoteDataSource);
  
  final IAIGenerationRemoteDataSource _aiGenerationRemoteDataSource;

  @override
  Future<Either<Failure, List<FlashcardCandidateModel>>>
      generateFlashcardsFromText({required String text}) async {
    try {
      final flashcards = await _aiGenerationRemoteDataSource
          .generateFlashcardsFromText(text: text);
      return Right(flashcards);
    } on DioException catch (e) {
      final message = e.message ?? 'AI Generation Failed';
      return Left(Failure.aigenerationFailure(message: message));
    } catch (e) {
      return Left(Failure.failure(message: e.toString()));
    }
  }
}
```

---

### Step 7: Run Code Generation

**Commands to execute:**

```bash
# Generate injectable configuration
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

### Step 8: Testing the Implementation

**Create test file:** `test/core/services/openrouter_service_test.dart`

**Basic test structure:**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x10devs/core/errors/openrouter_exception.dart';
import 'package:x10devs/core/services/openrouter_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late OpenRouterService service;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    service = OpenRouterService(
      dio: mockDio,
      apiKey: 'test-api-key',
    );
  });

  group('OpenRouterService', () {
    test('should throw exception when API key is empty', () {
      expect(
        () => OpenRouterService(dio: mockDio, apiKey: ''),
        throwsA(isA<OpenRouterException>()),
      );
    });

    test('should generate flashcards successfully', () async {
      // Arrange
      final mockResponse = {
        'choices': [
          {
            'message': {
              'content': '{"flashcards": [{"front": "Q1", "back": "A1"}]}'
            }
          }
        ]
      };

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await service.generateFlashcards(text: 'Test text');

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.front, 'Q1');
      expect(result.first.back, 'A1');
    });

    test('should throw validation exception for empty text', () async {
      // Act & Assert
      expect(
        () => service.generateFlashcards(text: ''),
        throwsA(isA<OpenRouterException>()),
      );
    });

    test('should handle network errors', () async {
      // Arrange
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenThrow(DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act & Assert
      expect(
        () => service.generateFlashcards(text: 'Test'),
        throwsA(isA<OpenRouterException>()),
      );
    });
  });
}
```

---

### Step 9: Update UI to Handle New Error Types

**File:** `lib/features/flashcard/presentation/bloc/ai_generation_cubit.dart`

**No changes needed** - the Cubit already handles errors properly through the repository layer.

**Optional enhancement** - Add more specific error messages in the UI:

```dart
// In the widget that displays errors
BlocListener<AiGenerationCubit, AiGenerationState>(
  listener: (context, state) {
    state.maybeWhen(
      error: (failure) {
        final message = failure.when(
          aigenerationFailure: (msg) => msg,
          failure: (msg) => 'An unexpected error occurred',
          serverFailure: (msg) => 'Server error: $msg',
          // ... other cases
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      orElse: () {},
    );
  },
  child: // ... your widget
)
```

---

### Step 10: Documentation and Final Checks

**Create README for the service:** `lib/core/services/README.md`

**Content:**
```markdown
# OpenRouter Service

## Overview
This service integrates with OpenRouter API to provide AI-powered flashcard generation.

## Configuration
1. Add your API key to `.env`:
   ```
   OPENROUTER_API_KEY=your-key-here
   ```

2. The service is automatically registered via dependency injection.

## Usage
The service is used internally by `AIGenerationRemoteDataSourceImpl`. 
No direct usage in UI components is needed.

## Error Handling
All errors are wrapped in `OpenRouterException` with specific error types.
The repository layer converts these to `Failure` objects for the presentation layer.

## Testing
Run tests with: `flutter test test/core/services/openrouter_service_test.dart`

## Model Configuration
Default model: `google/gemini-2.0-flash-exp:free`

To use a different model, modify the `defaultModel` constant in the service.
```

**Final Checklist:**
- [ ] `.env` file created with API key
- [ ] `.env` added to `.gitignore`
- [ ] `OpenRouterException` class created
- [ ] `OpenRouterService` implemented
- [ ] `OpenRouterModule` created for DI
- [ ] `AIGenerationRemoteDataSourceImpl` updated
- [ ] Code generation completed (`build_runner`)
- [ ] Unit tests written and passing
- [ ] Documentation created
- [ ] Manual testing performed with real API key

---

## 8. Additional Considerations

### 8.1 Performance Optimization

**Caching Strategy:**
```dart
// Consider implementing a simple cache to avoid redundant API calls
class OpenRouterService {
  final Map<String, List<FlashcardCandidateModel>> _cache = {};
  
  Future<List<FlashcardCandidateModel>> generateFlashcards({
    required String text,
    bool useCache = true,
  }) async {
    if (useCache && _cache.containsKey(text)) {
      return _cache[text]!;
    }
    
    final result = await _generateFlashcardsInternal(text);
    _cache[text] = result;
    return result;
  }
}
```

### 8.2 Monitoring and Analytics

**Track API Usage:**
```dart
// Add logging for monitoring
Future<List<FlashcardCandidateModel>> generateFlashcards({
  required String text,
}) async {
  final startTime = DateTime.now();
  
  try {
    final result = await _makeApiCall(text);
    final duration = DateTime.now().difference(startTime);
    
    // Log success
    debugPrint('OpenRouter: Generated ${result.length} flashcards in ${duration.inMilliseconds}ms');
    
    return result;
  } catch (e) {
    final duration = DateTime.now().difference(startTime);
    
    // Log failure
    debugPrint('OpenRouter: Failed after ${duration.inMilliseconds}ms - $e');
    
    rethrow;
  }
}
```

### 8.3 Future Enhancements

1. **Model Selection UI**: Allow users to choose different AI models
2. **Retry Logic**: Implement automatic retry with exponential backoff
3. **Streaming Responses**: Use Server-Sent Events for real-time flashcard generation
4. **Batch Processing**: Generate flashcards for multiple texts in parallel
5. **Quality Scoring**: Implement AI-based quality assessment for generated flashcards

---

## Summary

This implementation plan provides a complete, production-ready integration of OpenRouter service into the Flutter application. The design follows Clean Architecture principles, uses proper dependency injection, implements comprehensive error handling, and maintains security best practices.

Key benefits of this implementation:
- **Type-safe**: Full type safety with Dart's strong typing
- **Testable**: Easy to mock and test all components
- **Maintainable**: Clear separation of concerns
- **Secure**: Proper API key management and error sanitization
- **Robust**: Comprehensive error handling for all scenarios
- **Scalable**: Easy to extend with new features and models

Follow the step-by-step implementation plan to integrate this service into your application successfully.

