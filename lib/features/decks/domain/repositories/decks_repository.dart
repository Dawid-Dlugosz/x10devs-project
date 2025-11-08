import 'package:fpdart/fpdart.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';

abstract class IDecksRepository {
  Future<Either<Failure, List<DeckModel>>> getDecks();
  Future<Either<Failure, DeckModel>> createDeck({required String name});
  Future<Either<Failure, DeckModel>> updateDeck({
    required int deckId,
    required String newName,
  });
  Future<Either<Failure, void>> deleteDeck({required int deckId});
}
