import 'package:x10devs/features/decks/data/models/deck_model.dart';

abstract class IDecksRemoteDataSource {
  Future<List<DeckModel>> getDecks();
  Future<DeckModel> createDeck({required String name});
  Future<DeckModel> updateDeck({
    required int deckId,
    required String newName,
  });
  Future<void> deleteDeck({required int deckId});
}
