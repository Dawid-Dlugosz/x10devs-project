// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeckModel _$DeckModelFromJson(Map<String, dynamic> json) => _DeckModel(
  id: (json['id'] as num).toInt(),
  userId: json['user_id'] as String,
  name: json['name'] as String,
  flashcardCount: (json['flashcard_count'] as num).toInt(),
  createdAt: (json['created_at'] as num).toInt(),
);

Map<String, dynamic> _$DeckModelToJson(_DeckModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'flashcard_count': instance.flashcardCount,
      'created_at': instance.createdAt,
    };
