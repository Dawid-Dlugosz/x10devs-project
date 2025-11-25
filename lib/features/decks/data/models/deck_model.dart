import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_model.freezed.dart';
part 'deck_model.g.dart';

@freezed
abstract class DeckModel with _$DeckModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DeckModel({
    required int id,
    required String userId,
    required String name,
    required int flashcardCount,
    required DateTime createdAt,
  }) = _DeckModel;

  factory DeckModel.fromJson(Map<String, dynamic> json) =>
      _$DeckModelFromJson(json);
}
