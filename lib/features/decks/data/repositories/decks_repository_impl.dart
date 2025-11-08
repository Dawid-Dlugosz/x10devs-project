import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';
import 'package:x10devs/features/decks/domain/data_sources/decks_remote_data_source.dart';
import 'package:x10devs/features/decks/domain/repositories/decks_repository.dart';

@LazySingleton(as: IDecksRepository)
class DecksRepositoryImpl implements IDecksRepository {
  DecksRepositoryImpl(this._decksRemoteDataSource);

  final IDecksRemoteDataSource _decksRemoteDataSource;

  @override
  Future<Either<Failure, DeckModel>> createDeck({required String name}) async {
    try {
      final deck = await _decksRemoteDataSource.createDeck(name: name);
      return Right(deck);
    } on PostgrestException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDeck({required int deckId}) async {
    try {
      await _decksRemoteDataSource.deleteDeck(deckId: deckId);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<DeckModel>>> getDecks() async {
    try {
      final decks = await _decksRemoteDataSource.getDecks();
      return Right(decks);
    } on PostgrestException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, DeckModel>> updateDeck(
      {required int deckId, required String newName}) async {
    try {
      final deck = await _decksRemoteDataSource.updateDeck(
          deckId: deckId, newName: newName);
      return Right(deck);
    } on PostgrestException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    }
  }
}
