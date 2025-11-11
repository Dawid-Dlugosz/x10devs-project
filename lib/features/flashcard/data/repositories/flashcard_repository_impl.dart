import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/data_sources/flashcard_remote_data_source.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../models/flashcard_candidate_model.dart';
import '../models/flashcard_model.dart';

@LazySingleton(as: IFlashcardRepository)
class FlashcardRepositoryImpl implements IFlashcardRepository {
  FlashcardRepositoryImpl(this._flashcardsRemoteDataSource);

  final IFlashcardsRemoteDataSource _flashcardsRemoteDataSource;

  @override
  Future<Either<Failure, FlashcardModel>> createFlashcard({
    required int deckId,
    required String front,
    required String back,
    bool isAiGenerated = false,
  }) async {
    try {
      final flashcard = await _flashcardsRemoteDataSource.createFlashcard(
        deckId: deckId,
        front: front,
        back: back,
        isAiGenerated: isAiGenerated,
      );
      return Right(flashcard);
    } on PostgrestException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } catch (e) {
      return Left(Failure.failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createFlashcards({
    required int deckId,
    required List<FlashcardCandidateModel> candidates,
  }) async {
    try {
      final flashcardsToCreate = candidates
          .map(
            (c) => {
              'deck_id': deckId,
              'front': c.front,
              'back': c.back,
              'is_ai_generated': true,
              'was_modified_by_user': c.wasModified,
            },
          )
          .toList();
      await _flashcardsRemoteDataSource.createFlashcards(
        flashcards: flashcardsToCreate,
      );
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } catch (e) {
      return Left(Failure.failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFlashcard(
      {required int flashcardId}) async {
    try {
      await _flashcardsRemoteDataSource.deleteFlashcard(flashcardId: flashcardId);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } catch (e) {
      return Left(Failure.failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FlashcardModel>>> getFlashcardsForDeck(
      {required int deckId}) async {
    try {
      final flashcards = await _flashcardsRemoteDataSource.getFlashcardsForDeck(
          deckId: deckId);
      return Right(flashcards);
    } on PostgrestException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } catch (e) {
      return Left(Failure.failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FlashcardModel>> updateFlashcard(
      {required int flashcardId,
      required String newFront,
      required String newBack,
      bool wasModifiedByUser = true}) async {
    try {
      final flashcard = await _flashcardsRemoteDataSource.updateFlashcard(
        flashcardId: flashcardId,
        newFront: newFront,
        newBack: newBack,
        wasModifiedByUser: wasModifiedByUser,
      );
      return Right(flashcard);
    } on PostgrestException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } catch (e) {
      return Left(Failure.failure(message: e.toString()));
    }
  }
}
