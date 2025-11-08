import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/data_sources/ai_generation_remote_data_source.dart';
import '../../domain/repositories/ai_generation_repository.dart';

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
      return Left(Failure.aigenerationFailure(message: e.message ?? 'AI Generation Failed'));
    } catch (e) {
      return Left(Failure.failure(message: e.toString()));
    }
  }
}
