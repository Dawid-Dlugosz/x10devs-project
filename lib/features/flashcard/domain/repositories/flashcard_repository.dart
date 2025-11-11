import 'package:fpdart/fpdart.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/flashcard_model.dart';

abstract class IFlashcardRepository {
  Future<Either<Failure, List<FlashcardModel>>> getFlashcardsForDeck({
    required int deckId,
  });

  Future<Either<Failure, void>> createFlashcards({
    required int deckId,
    required List<FlashcardCandidateModel> candidates,
  });

  Future<Either<Failure, FlashcardModel>> createFlashcard({
    required int deckId,
    required String front,
    required String back,
    bool isAiGenerated = false,
  });

  Future<Either<Failure, FlashcardModel>> updateFlashcard({
    required int flashcardId,
    required String newFront,
    required String newBack,
    bool wasModifiedByUser = true,
  });

  Future<Either<Failure, void>> deleteFlashcard({required int flashcardId});
}
