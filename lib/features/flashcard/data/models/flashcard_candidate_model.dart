import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_candidate_model.freezed.dart';
part 'flashcard_candidate_model.g.dart';

@freezed
abstract class FlashcardCandidateModel with _$FlashcardCandidateModel {
  const factory FlashcardCandidateModel({
    required String front,
    required String back,
    @Default(false) bool wasModified,
  }) = _FlashcardCandidateModel;

  factory FlashcardCandidateModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardCandidateModelFromJson(json);
}
