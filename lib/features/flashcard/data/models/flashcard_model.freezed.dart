// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flashcard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlashcardModel {

 int get id; int get deckId; String get front; String get back; bool get isAiGenerated; bool get wasModifiedByUser; int get createdAt;
/// Create a copy of FlashcardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashcardModelCopyWith<FlashcardModel> get copyWith => _$FlashcardModelCopyWithImpl<FlashcardModel>(this as FlashcardModel, _$identity);

  /// Serializes this FlashcardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashcardModel&&(identical(other.id, id) || other.id == id)&&(identical(other.deckId, deckId) || other.deckId == deckId)&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.isAiGenerated, isAiGenerated) || other.isAiGenerated == isAiGenerated)&&(identical(other.wasModifiedByUser, wasModifiedByUser) || other.wasModifiedByUser == wasModifiedByUser)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deckId,front,back,isAiGenerated,wasModifiedByUser,createdAt);

@override
String toString() {
  return 'FlashcardModel(id: $id, deckId: $deckId, front: $front, back: $back, isAiGenerated: $isAiGenerated, wasModifiedByUser: $wasModifiedByUser, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FlashcardModelCopyWith<$Res>  {
  factory $FlashcardModelCopyWith(FlashcardModel value, $Res Function(FlashcardModel) _then) = _$FlashcardModelCopyWithImpl;
@useResult
$Res call({
 int id, int deckId, String front, String back, bool isAiGenerated, bool wasModifiedByUser, int createdAt
});




}
/// @nodoc
class _$FlashcardModelCopyWithImpl<$Res>
    implements $FlashcardModelCopyWith<$Res> {
  _$FlashcardModelCopyWithImpl(this._self, this._then);

  final FlashcardModel _self;
  final $Res Function(FlashcardModel) _then;

/// Create a copy of FlashcardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deckId = null,Object? front = null,Object? back = null,Object? isAiGenerated = null,Object? wasModifiedByUser = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,deckId: null == deckId ? _self.deckId : deckId // ignore: cast_nullable_to_non_nullable
as int,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as String,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as String,isAiGenerated: null == isAiGenerated ? _self.isAiGenerated : isAiGenerated // ignore: cast_nullable_to_non_nullable
as bool,wasModifiedByUser: null == wasModifiedByUser ? _self.wasModifiedByUser : wasModifiedByUser // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FlashcardModel].
extension FlashcardModelPatterns on FlashcardModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashcardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashcardModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashcardModel value)  $default,){
final _that = this;
switch (_that) {
case _FlashcardModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashcardModel value)?  $default,){
final _that = this;
switch (_that) {
case _FlashcardModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int deckId,  String front,  String back,  bool isAiGenerated,  bool wasModifiedByUser,  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlashcardModel() when $default != null:
return $default(_that.id,_that.deckId,_that.front,_that.back,_that.isAiGenerated,_that.wasModifiedByUser,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int deckId,  String front,  String back,  bool isAiGenerated,  bool wasModifiedByUser,  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _FlashcardModel():
return $default(_that.id,_that.deckId,_that.front,_that.back,_that.isAiGenerated,_that.wasModifiedByUser,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int deckId,  String front,  String back,  bool isAiGenerated,  bool wasModifiedByUser,  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FlashcardModel() when $default != null:
return $default(_that.id,_that.deckId,_that.front,_that.back,_that.isAiGenerated,_that.wasModifiedByUser,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _FlashcardModel implements FlashcardModel {
  const _FlashcardModel({required this.id, required this.deckId, required this.front, required this.back, required this.isAiGenerated, required this.wasModifiedByUser, required this.createdAt});
  factory _FlashcardModel.fromJson(Map<String, dynamic> json) => _$FlashcardModelFromJson(json);

@override final  int id;
@override final  int deckId;
@override final  String front;
@override final  String back;
@override final  bool isAiGenerated;
@override final  bool wasModifiedByUser;
@override final  int createdAt;

/// Create a copy of FlashcardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashcardModelCopyWith<_FlashcardModel> get copyWith => __$FlashcardModelCopyWithImpl<_FlashcardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlashcardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashcardModel&&(identical(other.id, id) || other.id == id)&&(identical(other.deckId, deckId) || other.deckId == deckId)&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.isAiGenerated, isAiGenerated) || other.isAiGenerated == isAiGenerated)&&(identical(other.wasModifiedByUser, wasModifiedByUser) || other.wasModifiedByUser == wasModifiedByUser)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deckId,front,back,isAiGenerated,wasModifiedByUser,createdAt);

@override
String toString() {
  return 'FlashcardModel(id: $id, deckId: $deckId, front: $front, back: $back, isAiGenerated: $isAiGenerated, wasModifiedByUser: $wasModifiedByUser, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FlashcardModelCopyWith<$Res> implements $FlashcardModelCopyWith<$Res> {
  factory _$FlashcardModelCopyWith(_FlashcardModel value, $Res Function(_FlashcardModel) _then) = __$FlashcardModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int deckId, String front, String back, bool isAiGenerated, bool wasModifiedByUser, int createdAt
});




}
/// @nodoc
class __$FlashcardModelCopyWithImpl<$Res>
    implements _$FlashcardModelCopyWith<$Res> {
  __$FlashcardModelCopyWithImpl(this._self, this._then);

  final _FlashcardModel _self;
  final $Res Function(_FlashcardModel) _then;

/// Create a copy of FlashcardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deckId = null,Object? front = null,Object? back = null,Object? isAiGenerated = null,Object? wasModifiedByUser = null,Object? createdAt = null,}) {
  return _then(_FlashcardModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,deckId: null == deckId ? _self.deckId : deckId // ignore: cast_nullable_to_non_nullable
as int,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as String,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as String,isAiGenerated: null == isAiGenerated ? _self.isAiGenerated : isAiGenerated // ignore: cast_nullable_to_non_nullable
as bool,wasModifiedByUser: null == wasModifiedByUser ? _self.wasModifiedByUser : wasModifiedByUser // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
