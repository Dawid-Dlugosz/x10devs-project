import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';
import 'package:x10devs/features/decks/domain/data_sources/decks_remote_data_source.dart';

@LazySingleton(as: IDecksRemoteDataSource)
class DecksRemoteDataSourceImpl implements IDecksRemoteDataSource {
  DecksRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<DeckModel> createDeck({required String name}) async {
    final userId = _supabaseClient.auth.currentUser!.id;
    final response = await _supabaseClient
        .from('decks')
        .insert({'name': name, 'user_id': userId}).select();
    return DeckModel.fromJson(response.first);
  }

  @override
  Future<void> deleteDeck({required int deckId}) async {
    await _supabaseClient.from('decks').delete().eq('id', deckId);
  }

  @override
  Future<List<DeckModel>> getDecks() async {
    final response = await _supabaseClient.from('decks').select();
    return response.map((deck) => DeckModel.fromJson(deck)).toList();
  }

  @override
  Future<DeckModel> updateDeck(
      {required int deckId, required String newName}) async {
    final response = await _supabaseClient
        .from('decks')
        .update({'name': newName})
        .eq('id', deckId)
        .select();
    return DeckModel.fromJson(response.first);
  }
}
