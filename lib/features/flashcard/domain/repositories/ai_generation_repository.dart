import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/flashcard_candidate_model.dart';

abstract class IAIGenerationRepository {
  Future<Either<Failure, List<FlashcardCandidateModel>>>
      generateFlashcardsFromText({
    required String text,
  });
}
