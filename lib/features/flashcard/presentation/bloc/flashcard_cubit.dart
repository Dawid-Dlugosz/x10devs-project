import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:x10devs/features/flashcard/domain/repositories/flashcard_repository.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_state.dart';

@injectable
class FlashcardCubit extends Cubit<FlashcardState> {
  FlashcardCubit(this._flashcardRepository) : super(const FlashcardState.initial());

  final IFlashcardRepository _flashcardRepository;

  Future<void> getFlashcards(int deckId) async {
    emit(const FlashcardState.loading());
    final result = await _flashcardRepository.getFlashcardsForDeck(deckId: deckId);
    result.fold(
      (failure) => emit(FlashcardState.error(failure: failure)),
      (flashcards) => emit(FlashcardState.loaded(flashcards: flashcards)),
    );
  }

  Future<void> createFlashcard({
    required int deckId,
    required String front,
    required String back,
    bool isAiGenerated = false,
  }) async {
    emit(const FlashcardState.loading());
    final result = await _flashcardRepository.createFlashcard(
      deckId: deckId,
      front: front,
      back: back,
      isAiGenerated: isAiGenerated,
    );
    result.fold(
      (failure) => emit(FlashcardState.error(failure: failure)),
      (_) => getFlashcards(deckId),
    );
  }

  Future<void> updateFlashcard({
    required int deckId, // Potrzebne do odświeżenia listy
    required int flashcardId,
    required String newFront,
    required String newBack,
  }) async {
    emit(const FlashcardState.loading());
    final result = await _flashcardRepository.updateFlashcard(
      flashcardId: flashcardId,
      newFront: newFront,
      newBack: newBack,
    );
    result.fold(
      (failure) => emit(FlashcardState.error(failure: failure)),
      (_) => getFlashcards(deckId),
    );
  }

  Future<void> deleteFlashcard(int deckId, int flashcardId) async {
    emit(const FlashcardState.loading());
    final result = await _flashcardRepository.deleteFlashcard(flashcardId: flashcardId);
    result.fold(
      (failure) => emit(FlashcardState.error(failure: failure)),
      (_) => getFlashcards(deckId),
    );
  }
}
