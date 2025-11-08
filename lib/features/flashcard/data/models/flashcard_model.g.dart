// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlashcardModel _$FlashcardModelFromJson(Map<String, dynamic> json) =>
    _FlashcardModel(
      id: (json['id'] as num).toInt(),
      deckId: (json['deck_id'] as num).toInt(),
      front: json['front'] as String,
      back: json['back'] as String,
      isAiGenerated: json['is_ai_generated'] as bool,
      wasModifiedByUser: json['was_modified_by_user'] as bool,
      createdAt: (json['created_at'] as num).toInt(),
    );

Map<String, dynamic> _$FlashcardModelToJson(_FlashcardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deck_id': instance.deckId,
      'front': instance.front,
      'back': instance.back,
      'is_ai_generated': instance.isAiGenerated,
      'was_modified_by_user': instance.wasModifiedByUser,
      'created_at': instance.createdAt,
    };
