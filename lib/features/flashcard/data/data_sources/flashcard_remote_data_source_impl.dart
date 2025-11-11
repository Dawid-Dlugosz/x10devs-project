import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../flashcard/data/models/flashcard_model.dart';
import '../../domain/data_sources/flashcard_remote_data_source.dart';

@LazySingleton(as: IFlashcardsRemoteDataSource)
class FlashcardsRemoteDataSourceImpl implements IFlashcardsRemoteDataSource {
  FlashcardsRemoteDataSourceImpl(this._supabaseClient);
  final SupabaseClient _supabaseClient;

  @override
  Future<FlashcardModel> createFlashcard({
    required int deckId,
    required String front,
    required String back,
    bool isAiGenerated = false,
  }) async {
    final response = await _supabaseClient.from('flashcards').insert({
      'deck_id': deckId,
      'front': front,
      'back': back,
      'is_ai_generated': isAiGenerated,
    }).select();
    return FlashcardModel.fromJson(response.first);
  }

  @override
  Future<void> deleteFlashcard({required int flashcardId}) async {
    await _supabaseClient.from('flashcards').delete().eq('id', flashcardId);
  }

  @override
  Future<List<FlashcardModel>> getFlashcardsForDeck(
      {required int deckId}) async {
    final response = await _supabaseClient
        .from('flashcards')
        .select()
        .eq('deck_id', deckId);
    return response
        .map<FlashcardModel>((e) => FlashcardModel.fromJson(e))
        .toList();
  }

  @override
  Future<FlashcardModel> updateFlashcard(
      {required int flashcardId,
      required String newFront,
      required String newBack,
      bool wasModifiedByUser = true}) async {
    final response = await _supabaseClient
        .from('flashcards')
        .update({
          'front': newFront,
          'back': newBack,
          'was_modified_by_user': wasModifiedByUser
        })
        .eq('id', flashcardId)
        .select();
    return FlashcardModel.fromJson(response.first);
  }

  @override
  Future<void> createFlashcards(
      {required List<Map<String, dynamic>> flashcards}) async {
    await _supabaseClient.from('flashcards').insert(flashcards);
  }
}
