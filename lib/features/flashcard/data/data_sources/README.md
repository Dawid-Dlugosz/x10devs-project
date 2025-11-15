# AI Generation Data Source

## Overview
This data source integrates with OpenRouter API to provide AI-powered flashcard generation from text input.

## Configuration

### Environment Variables
Add the following to your `.env` file:

```env
OPENROUTER_API_KEY=sk-or-v1-your-api-key-here
OPENROUTER_BASE_URL=https://openrouter.ai/api/v1
```

**Get your API key**: https://openrouter.ai/keys

### Dependency Injection
The data source is automatically registered via `injectable` as a lazy singleton:

```dart
@LazySingleton(as: IAIGenerationRemoteDataSource)
class AIGenerationRemoteDataSourceImpl
```

## Usage

The data source is used internally by `AIGenerationRepositoryImpl`. No direct usage in UI components is needed.

```dart
// In repository
final flashcards = await _aiGenerationRemoteDataSource
    .generateFlashcardsFromText(text: userText);
```

## Features

### AI Model
- **Default Model**: `openai/gpt-4o-mini`
- **Provider**: OpenRouter (unified API for multiple LLM providers)
- **Response Format**: Structured JSON with JSON Schema validation (native support)
- **Why GPT-4o-mini?**: Full support for `response_format` with strict JSON Schema, ensuring clean JSON output without markdown formatting

### Input Validation
- Text cannot be empty
- Maximum text length: 10,000 characters
- Automatic trimming of whitespace

### Output
Returns a list of `FlashcardCandidateModel` with:
- `front`: Question or prompt
- `back`: Answer or explanation
- Expected: 3-10 flashcards per request

## Error Handling

All errors are converted to `DioException` for consistency with the repository layer:

| Error Type | Status Code | Message |
|------------|-------------|---------|
| Authentication | 401 | Invalid API key |
| Rate Limit | 429 | Rate limit exceeded |
| Invalid Request | 400 | Invalid request format |
| Model Not Found | 404 | Model configuration error |
| Server Error | 5xx | Service temporarily unavailable |
| Timeout | - | Connection/receive timeout |
| Network | - | Connection error |
| Parsing | - | Invalid response structure |
| Validation | - | Input validation failed |

## Performance

### Timeouts
- **Connect Timeout**: 30 seconds
- **Receive Timeout**: 60 seconds
- **Send Timeout**: 30 seconds

### Monitoring
The data source logs performance metrics in debug mode:
- Request start with text length
- Success with flashcard count and duration
- Errors with type and duration

Example logs:
```
OpenRouter: Starting flashcard generation (text length: 1234)
OpenRouter: Generated 5 flashcards in 2341ms
```

## API Request Structure

### Headers
```dart
{
  'Authorization': 'Bearer $apiKey',
  'HTTP-Referer': 'https://x10devs.app',
  'X-Title': 'X10Devs Flashcard App',
  'Content-Type': 'application/json',
}
```

### Payload
```json
{
  "model": "openai/gpt-4o-mini",
  "messages": [
    {
      "role": "system",
      "content": "You are an expert flashcard creator..."
    },
    {
      "role": "user",
      "content": "User's text here"
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
              "required": ["front", "back"]
            }
          }
        },
        "required": ["flashcards"]
      }
    }
  },
  "temperature": 0.7,
  "max_tokens": 2000,
  "top_p": 1.0
}
```

## Security Considerations

### API Key Management
- ✅ API key stored in `.env` file (excluded from version control)
- ✅ Loaded via `flutter_dotenv`
- ✅ Validated on initialization (throws exception if empty)
- ❌ Never hardcode API keys in source code

### Data Privacy
- User-provided text is sent to external AI service (OpenRouter)
- No sensitive personal information should be included in text
- Consider privacy policy disclosure to users

### Rate Limiting
- OpenRouter enforces rate limits based on your plan
- Client-side: Show loading states to prevent multiple simultaneous requests
- Consider implementing request queuing for better UX

## Troubleshooting

### "OpenRouter API key is not configured"
- Ensure `.env` file exists in project root
- Verify `OPENROUTER_API_KEY` is set
- Run `flutter pub run build_runner build` after adding the key

### "Invalid API key"
- Check that your API key is valid at https://openrouter.ai/keys
- Ensure no extra spaces or quotes in `.env` file

### "Rate limit exceeded"
- Wait before making another request
- Consider upgrading your OpenRouter plan
- Implement request throttling

### "Connection timeout"
- Check internet connection
- Verify OpenRouter service status
- Consider increasing timeout values if needed

## Future Enhancements

Potential improvements for consideration:
1. **Caching**: Cache results for identical text inputs
2. **Model Selection**: Allow users to choose different AI models
3. **Retry Logic**: Automatic retry with exponential backoff
4. **Streaming**: Use SSE for real-time flashcard generation
5. **Batch Processing**: Generate flashcards for multiple texts in parallel
6. **Quality Scoring**: AI-based quality assessment for generated flashcards

## Related Files

- Interface: `lib/features/flashcard/domain/data_sources/ai_generation_remote_data_source.dart`
- Repository: `lib/features/flashcard/data/repositories/ai_generation_repository_impl.dart`
- Model: `lib/features/flashcard/data/models/flashcard_candidate_model.dart`
- DI Config: `lib/core/di/injectable_module.dart`
- Error Types: `lib/core/errors/openrouter_exception.dart`

