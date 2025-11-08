import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';

part 'decks_state.freezed.dart';

@freezed
sealed class DecksState with _$DecksState {
  const factory DecksState.initial() = _Initial;
  const factory DecksState.loading() = _Loading;
  const factory DecksState.loaded({required List<DeckModel> decks}) = _Loaded;
  const factory DecksState.error({required Failure failure}) = _Error;
}
