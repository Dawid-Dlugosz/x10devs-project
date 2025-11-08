import '../../data/models/flashcard_model.dart';

abstract class IFlashcardsRemoteDataSource {
  Future<List<FlashcardModel>> getFlashcardsForDeck({
    required int deckId,
  });

  Future<FlashcardModel> createFlashcard({
    required int deckId,
    required String front,
    required String back,
    bool isAiGenerated = false,
  });

  Future<FlashcardModel> updateFlashcard({
    required int flashcardId,
    required String newFront,
    required String newBack,
    bool wasModifiedByUser = true,
  });

  Future<void> deleteFlashcard({required int flashcardId});
}
