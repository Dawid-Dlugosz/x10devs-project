import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/data_sources/ai_generation_remote_data_source.dart';
import '../models/flashcard_candidate_model.dart';

@LazySingleton(as: IAIGenerationRemoteDataSource)
class AIGenerationRemoteDataSourceImpl
    implements IAIGenerationRemoteDataSource {
  AIGenerationRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<List<FlashcardCandidateModel>> generateFlashcardsFromText(
      {required String text}) async {
    // This is a mock implementation.
    // In a real scenario, you would make an HTTP request to an AI service.
    // For example:
    // final response = await _dio.post(
    //   'https://api.openrouter.ai/v1/chat/completions',
    //   data: {
    //     "model": "google/gemma-7b-it:free",
    //     "messages": [
    //       {"role": "user", "content": "Generate flashcards from this text: $text"}
    //     ]
    //   },
    // );
    // return (response.data['choices'] as List)
    //     .map((e) => FlashcardCandidateModel.fromJson(e['message']['content']))
    //     .toList();

    await Future.delayed(const Duration(seconds: 2));
    if (text.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'Text cannot be empty',
      );
    }
    return [
      const FlashcardCandidateModel(front: 'Mock Front 1', back: 'Mock Back 1'),
      const FlashcardCandidateModel(front: 'Mock Front 2', back: 'Mock Back 2'),
    ];
  }
}
