// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flashcard_candidate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlashcardCandidateModel {

 String get front; String get back; bool get wasModified;
/// Create a copy of FlashcardCandidateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashcardCandidateModelCopyWith<FlashcardCandidateModel> get copyWith => _$FlashcardCandidateModelCopyWithImpl<FlashcardCandidateModel>(this as FlashcardCandidateModel, _$identity);

  /// Serializes this FlashcardCandidateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashcardCandidateModel&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.wasModified, wasModified) || other.wasModified == wasModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,front,back,wasModified);

@override
String toString() {
  return 'FlashcardCandidateModel(front: $front, back: $back, wasModified: $wasModified)';
}


}

/// @nodoc
abstract mixin class $FlashcardCandidateModelCopyWith<$Res>  {
  factory $FlashcardCandidateModelCopyWith(FlashcardCandidateModel value, $Res Function(FlashcardCandidateModel) _then) = _$FlashcardCandidateModelCopyWithImpl;
@useResult
$Res call({
 String front, String back, bool wasModified
});




}
/// @nodoc
class _$FlashcardCandidateModelCopyWithImpl<$Res>
    implements $FlashcardCandidateModelCopyWith<$Res> {
  _$FlashcardCandidateModelCopyWithImpl(this._self, this._then);

  final FlashcardCandidateModel _self;
  final $Res Function(FlashcardCandidateModel) _then;

/// Create a copy of FlashcardCandidateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? front = null,Object? back = null,Object? wasModified = null,}) {
  return _then(_self.copyWith(
front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as String,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as String,wasModified: null == wasModified ? _self.wasModified : wasModified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FlashcardCandidateModel].
extension FlashcardCandidateModelPatterns on FlashcardCandidateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashcardCandidateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashcardCandidateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashcardCandidateModel value)  $default,){
final _that = this;
switch (_that) {
case _FlashcardCandidateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashcardCandidateModel value)?  $default,){
final _that = this;
switch (_that) {
case _FlashcardCandidateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String front,  String back,  bool wasModified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlashcardCandidateModel() when $default != null:
return $default(_that.front,_that.back,_that.wasModified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String front,  String back,  bool wasModified)  $default,) {final _that = this;
switch (_that) {
case _FlashcardCandidateModel():
return $default(_that.front,_that.back,_that.wasModified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String front,  String back,  bool wasModified)?  $default,) {final _that = this;
switch (_that) {
case _FlashcardCandidateModel() when $default != null:
return $default(_that.front,_that.back,_that.wasModified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlashcardCandidateModel implements FlashcardCandidateModel {
  const _FlashcardCandidateModel({required this.front, required this.back, this.wasModified = false});
  factory _FlashcardCandidateModel.fromJson(Map<String, dynamic> json) => _$FlashcardCandidateModelFromJson(json);

@override final  String front;
@override final  String back;
@override@JsonKey() final  bool wasModified;

/// Create a copy of FlashcardCandidateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashcardCandidateModelCopyWith<_FlashcardCandidateModel> get copyWith => __$FlashcardCandidateModelCopyWithImpl<_FlashcardCandidateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlashcardCandidateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashcardCandidateModel&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.wasModified, wasModified) || other.wasModified == wasModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,front,back,wasModified);

@override
String toString() {
  return 'FlashcardCandidateModel(front: $front, back: $back, wasModified: $wasModified)';
}


}

/// @nodoc
abstract mixin class _$FlashcardCandidateModelCopyWith<$Res> implements $FlashcardCandidateModelCopyWith<$Res> {
  factory _$FlashcardCandidateModelCopyWith(_FlashcardCandidateModel value, $Res Function(_FlashcardCandidateModel) _then) = __$FlashcardCandidateModelCopyWithImpl;
@override @useResult
$Res call({
 String front, String back, bool wasModified
});




}
/// @nodoc
class __$FlashcardCandidateModelCopyWithImpl<$Res>
    implements _$FlashcardCandidateModelCopyWith<$Res> {
  __$FlashcardCandidateModelCopyWithImpl(this._self, this._then);

  final _FlashcardCandidateModel _self;
  final $Res Function(_FlashcardCandidateModel) _then;

/// Create a copy of FlashcardCandidateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? front = null,Object? back = null,Object? wasModified = null,}) {
  return _then(_FlashcardCandidateModel(
front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as String,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as String,wasModified: null == wasModified ? _self.wasModified : wasModified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
