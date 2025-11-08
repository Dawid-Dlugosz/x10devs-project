import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_model.freezed.dart';
part 'flashcard_model.g.dart';

@freezed
abstract class FlashcardModel with _$FlashcardModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FlashcardModel({
    required int id,
    required int deckId,
    required String front,
    required String back,
    required bool isAiGenerated,
    required bool wasModifiedByUser,
    required int createdAt,
  }) = _FlashcardModel;

  factory FlashcardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardModelFromJson(json);
}
