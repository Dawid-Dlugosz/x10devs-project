import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';


abstract class IAIGenerationRemoteDataSource {
  Future<List<FlashcardCandidateModel>> generateFlashcardsFromText({
    required String text,
  });
}
