import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:x10devs/core/errors/failure.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';

part 'ai_generation_state.freezed.dart';

@freezed
sealed class AiGenerationState with _$AiGenerationState {
  const factory AiGenerationState.initial() = _Initial;
  const factory AiGenerationState.loading() = _Loading;
  const factory AiGenerationState.loaded({
    required List<FlashcardCandidateModel> candidates,
  }) = _Loaded;
  const factory AiGenerationState.error({required Failure failure}) = _Error;
}
