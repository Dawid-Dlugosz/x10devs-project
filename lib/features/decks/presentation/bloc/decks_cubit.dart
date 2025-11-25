import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:x10devs/features/decks/domain/repositories/decks_repository.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_state.dart';

@lazySingleton
class DecksCubit extends Cubit<DecksState> {
  DecksCubit(this._decksRepository) : super(const DecksState.initial());

  final IDecksRepository _decksRepository;

  void updateDeckFlashcardCount(int deckId, int newFlashcardCount) {
    state.maybeMap(
      loaded: (loadedState) {
        final updatedDecks = loadedState.decks
            .map(
              (d) => d.id == deckId
                  ? d.copyWith(flashcardCount: newFlashcardCount)
                  : d,
            )
            .toList();
        emit(DecksState.loaded(decks: updatedDecks));
      },
      orElse: () {
        // Do nothing if the state is not loaded
      },
    );
  }

  Future<void> getDecks() async {
    emit(const DecksState.loading());
    final result = await _decksRepository.getDecks();

    result.fold((failure) => emit(DecksState.error(failure: failure)), (decks) {
      emit(DecksState.loaded(decks: decks));
    });
  }

  Future<void> createDeck(String name) async {
    emit(const DecksState.loading());
    final result = await _decksRepository.createDeck(name: name);
    result.fold(
      (failure) => emit(DecksState.error(failure: failure)),
      (deck) => emit(DecksState.created(deck: deck)),
    );
  }

  Future<void> updateDeck(int deckId, String newName) async {
    emit(const DecksState.loading());
    final result = await _decksRepository.updateDeck(
      deckId: deckId,
      newName: newName,
    );
    result.fold(
      (failure) => emit(DecksState.error(failure: failure)),
      (_) => getDecks(),
    );
  }

  Future<void> deleteDeck(int deckId) async {
    emit(const DecksState.loading());
    final result = await _decksRepository.deleteDeck(deckId: deckId);
    result.fold(
      (failure) => emit(DecksState.error(failure: failure)),
      (_) => getDecks(),
    );
  }
}
