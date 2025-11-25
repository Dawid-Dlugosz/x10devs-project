import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_model.dart';

part 'flashcard_state.freezed.dart';

@freezed
sealed class FlashcardState with _$FlashcardState {
  const factory FlashcardState.initial() = _Initial;
  const factory FlashcardState.loading() = _Loading;
  const factory FlashcardState.loaded({required List<FlashcardModel> flashcards}) = _Loaded;
  const factory FlashcardState.error({required Failure failure}) = _Error;
}






