// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deck_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeckModel {

 int get id; String get userId; String get name; int get flashcardCount; int get createdAt;
/// Create a copy of DeckModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeckModelCopyWith<DeckModel> get copyWith => _$DeckModelCopyWithImpl<DeckModel>(this as DeckModel, _$identity);

  /// Serializes this DeckModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeckModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.flashcardCount, flashcardCount) || other.flashcardCount == flashcardCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,flashcardCount,createdAt);

@override
String toString() {
  return 'DeckModel(id: $id, userId: $userId, name: $name, flashcardCount: $flashcardCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DeckModelCopyWith<$Res>  {
  factory $DeckModelCopyWith(DeckModel value, $Res Function(DeckModel) _then) = _$DeckModelCopyWithImpl;
@useResult
$Res call({
 int id, String userId, String name, int flashcardCount, int createdAt
});




}
/// @nodoc
class _$DeckModelCopyWithImpl<$Res>
    implements $DeckModelCopyWith<$Res> {
  _$DeckModelCopyWithImpl(this._self, this._then);

  final DeckModel _self;
  final $Res Function(DeckModel) _then;

/// Create a copy of DeckModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? flashcardCount = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,flashcardCount: null == flashcardCount ? _self.flashcardCount : flashcardCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeckModel].
extension DeckModelPatterns on DeckModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeckModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeckModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeckModel value)  $default,){
final _that = this;
switch (_that) {
case _DeckModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeckModel value)?  $default,){
final _that = this;
switch (_that) {
case _DeckModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String userId,  String name,  int flashcardCount,  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeckModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.flashcardCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String userId,  String name,  int flashcardCount,  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _DeckModel():
return $default(_that.id,_that.userId,_that.name,_that.flashcardCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String userId,  String name,  int flashcardCount,  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DeckModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.flashcardCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _DeckModel implements DeckModel {
  const _DeckModel({required this.id, required this.userId, required this.name, required this.flashcardCount, required this.createdAt});
  factory _DeckModel.fromJson(Map<String, dynamic> json) => _$DeckModelFromJson(json);

@override final  int id;
@override final  String userId;
@override final  String name;
@override final  int flashcardCount;
@override final  int createdAt;

/// Create a copy of DeckModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeckModelCopyWith<_DeckModel> get copyWith => __$DeckModelCopyWithImpl<_DeckModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeckModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeckModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.flashcardCount, flashcardCount) || other.flashcardCount == flashcardCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,flashcardCount,createdAt);

@override
String toString() {
  return 'DeckModel(id: $id, userId: $userId, name: $name, flashcardCount: $flashcardCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DeckModelCopyWith<$Res> implements $DeckModelCopyWith<$Res> {
  factory _$DeckModelCopyWith(_DeckModel value, $Res Function(_DeckModel) _then) = __$DeckModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String userId, String name, int flashcardCount, int createdAt
});




}
/// @nodoc
class __$DeckModelCopyWithImpl<$Res>
    implements _$DeckModelCopyWith<$Res> {
  __$DeckModelCopyWithImpl(this._self, this._then);

  final _DeckModel _self;
  final $Res Function(_DeckModel) _then;

/// Create a copy of DeckModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? flashcardCount = null,Object? createdAt = null,}) {
  return _then(_DeckModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,flashcardCount: null == flashcardCount ? _self.flashcardCount : flashcardCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
