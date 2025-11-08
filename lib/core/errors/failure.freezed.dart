// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {

 String get message;
/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureCopyWith<Failure> get copyWith => _$FailureCopyWithImpl<Failure>(this as Failure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $FailureCopyWith<$Res>  {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) _then) = _$FailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FailureCopyWithImpl<$Res>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._self, this._then);

  final Failure _self;
  final $Res Function(Failure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Failure value)?  failure,TResult Function( _ServerFailure value)?  serverFailure,TResult Function( _AuthFailure value)?  authFailure,TResult Function( _InvalidCredentialsFailure value)?  invalidCredentialsFailure,TResult Function( _EmailInUseFailure value)?  emailInUseFailure,TResult Function( _SessionExpiredFailure value)?  sessionExpiredFailure,TResult Function( _AIGenerationFailure value)?  aigenerationFailure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Failure() when failure != null:
return failure(_that);case _ServerFailure() when serverFailure != null:
return serverFailure(_that);case _AuthFailure() when authFailure != null:
return authFailure(_that);case _InvalidCredentialsFailure() when invalidCredentialsFailure != null:
return invalidCredentialsFailure(_that);case _EmailInUseFailure() when emailInUseFailure != null:
return emailInUseFailure(_that);case _SessionExpiredFailure() when sessionExpiredFailure != null:
return sessionExpiredFailure(_that);case _AIGenerationFailure() when aigenerationFailure != null:
return aigenerationFailure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Failure value)  failure,required TResult Function( _ServerFailure value)  serverFailure,required TResult Function( _AuthFailure value)  authFailure,required TResult Function( _InvalidCredentialsFailure value)  invalidCredentialsFailure,required TResult Function( _EmailInUseFailure value)  emailInUseFailure,required TResult Function( _SessionExpiredFailure value)  sessionExpiredFailure,required TResult Function( _AIGenerationFailure value)  aigenerationFailure,}){
final _that = this;
switch (_that) {
case _Failure():
return failure(_that);case _ServerFailure():
return serverFailure(_that);case _AuthFailure():
return authFailure(_that);case _InvalidCredentialsFailure():
return invalidCredentialsFailure(_that);case _EmailInUseFailure():
return emailInUseFailure(_that);case _SessionExpiredFailure():
return sessionExpiredFailure(_that);case _AIGenerationFailure():
return aigenerationFailure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Failure value)?  failure,TResult? Function( _ServerFailure value)?  serverFailure,TResult? Function( _AuthFailure value)?  authFailure,TResult? Function( _InvalidCredentialsFailure value)?  invalidCredentialsFailure,TResult? Function( _EmailInUseFailure value)?  emailInUseFailure,TResult? Function( _SessionExpiredFailure value)?  sessionExpiredFailure,TResult? Function( _AIGenerationFailure value)?  aigenerationFailure,}){
final _that = this;
switch (_that) {
case _Failure() when failure != null:
return failure(_that);case _ServerFailure() when serverFailure != null:
return serverFailure(_that);case _AuthFailure() when authFailure != null:
return authFailure(_that);case _InvalidCredentialsFailure() when invalidCredentialsFailure != null:
return invalidCredentialsFailure(_that);case _EmailInUseFailure() when emailInUseFailure != null:
return emailInUseFailure(_that);case _SessionExpiredFailure() when sessionExpiredFailure != null:
return sessionExpiredFailure(_that);case _AIGenerationFailure() when aigenerationFailure != null:
return aigenerationFailure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  failure,TResult Function( String message)?  serverFailure,TResult Function( String message)?  authFailure,TResult Function( String message)?  invalidCredentialsFailure,TResult Function( String message)?  emailInUseFailure,TResult Function( String message)?  sessionExpiredFailure,TResult Function( String message)?  aigenerationFailure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Failure() when failure != null:
return failure(_that.message);case _ServerFailure() when serverFailure != null:
return serverFailure(_that.message);case _AuthFailure() when authFailure != null:
return authFailure(_that.message);case _InvalidCredentialsFailure() when invalidCredentialsFailure != null:
return invalidCredentialsFailure(_that.message);case _EmailInUseFailure() when emailInUseFailure != null:
return emailInUseFailure(_that.message);case _SessionExpiredFailure() when sessionExpiredFailure != null:
return sessionExpiredFailure(_that.message);case _AIGenerationFailure() when aigenerationFailure != null:
return aigenerationFailure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  failure,required TResult Function( String message)  serverFailure,required TResult Function( String message)  authFailure,required TResult Function( String message)  invalidCredentialsFailure,required TResult Function( String message)  emailInUseFailure,required TResult Function( String message)  sessionExpiredFailure,required TResult Function( String message)  aigenerationFailure,}) {final _that = this;
switch (_that) {
case _Failure():
return failure(_that.message);case _ServerFailure():
return serverFailure(_that.message);case _AuthFailure():
return authFailure(_that.message);case _InvalidCredentialsFailure():
return invalidCredentialsFailure(_that.message);case _EmailInUseFailure():
return emailInUseFailure(_that.message);case _SessionExpiredFailure():
return sessionExpiredFailure(_that.message);case _AIGenerationFailure():
return aigenerationFailure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  failure,TResult? Function( String message)?  serverFailure,TResult? Function( String message)?  authFailure,TResult? Function( String message)?  invalidCredentialsFailure,TResult? Function( String message)?  emailInUseFailure,TResult? Function( String message)?  sessionExpiredFailure,TResult? Function( String message)?  aigenerationFailure,}) {final _that = this;
switch (_that) {
case _Failure() when failure != null:
return failure(_that.message);case _ServerFailure() when serverFailure != null:
return serverFailure(_that.message);case _AuthFailure() when authFailure != null:
return authFailure(_that.message);case _InvalidCredentialsFailure() when invalidCredentialsFailure != null:
return invalidCredentialsFailure(_that.message);case _EmailInUseFailure() when emailInUseFailure != null:
return emailInUseFailure(_that.message);case _SessionExpiredFailure() when sessionExpiredFailure != null:
return sessionExpiredFailure(_that.message);case _AIGenerationFailure() when aigenerationFailure != null:
return aigenerationFailure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Failure implements Failure {
  const _Failure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Failure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ServerFailure implements Failure {
  const _ServerFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerFailureCopyWith<_ServerFailure> get copyWith => __$ServerFailureCopyWithImpl<_ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.serverFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ServerFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory _$ServerFailureCopyWith(_ServerFailure value, $Res Function(_ServerFailure) _then) = __$ServerFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ServerFailureCopyWithImpl<$Res>
    implements _$ServerFailureCopyWith<$Res> {
  __$ServerFailureCopyWithImpl(this._self, this._then);

  final _ServerFailure _self;
  final $Res Function(_ServerFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ServerFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AuthFailure implements Failure {
  const _AuthFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthFailureCopyWith<_AuthFailure> get copyWith => __$AuthFailureCopyWithImpl<_AuthFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.authFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AuthFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory _$AuthFailureCopyWith(_AuthFailure value, $Res Function(_AuthFailure) _then) = __$AuthFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$AuthFailureCopyWithImpl<$Res>
    implements _$AuthFailureCopyWith<$Res> {
  __$AuthFailureCopyWithImpl(this._self, this._then);

  final _AuthFailure _self;
  final $Res Function(_AuthFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_AuthFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _InvalidCredentialsFailure implements Failure {
  const _InvalidCredentialsFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvalidCredentialsFailureCopyWith<_InvalidCredentialsFailure> get copyWith => __$InvalidCredentialsFailureCopyWithImpl<_InvalidCredentialsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvalidCredentialsFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.invalidCredentialsFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$InvalidCredentialsFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory _$InvalidCredentialsFailureCopyWith(_InvalidCredentialsFailure value, $Res Function(_InvalidCredentialsFailure) _then) = __$InvalidCredentialsFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$InvalidCredentialsFailureCopyWithImpl<$Res>
    implements _$InvalidCredentialsFailureCopyWith<$Res> {
  __$InvalidCredentialsFailureCopyWithImpl(this._self, this._then);

  final _InvalidCredentialsFailure _self;
  final $Res Function(_InvalidCredentialsFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_InvalidCredentialsFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _EmailInUseFailure implements Failure {
  const _EmailInUseFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailInUseFailureCopyWith<_EmailInUseFailure> get copyWith => __$EmailInUseFailureCopyWithImpl<_EmailInUseFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailInUseFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.emailInUseFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$EmailInUseFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory _$EmailInUseFailureCopyWith(_EmailInUseFailure value, $Res Function(_EmailInUseFailure) _then) = __$EmailInUseFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$EmailInUseFailureCopyWithImpl<$Res>
    implements _$EmailInUseFailureCopyWith<$Res> {
  __$EmailInUseFailureCopyWithImpl(this._self, this._then);

  final _EmailInUseFailure _self;
  final $Res Function(_EmailInUseFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_EmailInUseFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SessionExpiredFailure implements Failure {
  const _SessionExpiredFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionExpiredFailureCopyWith<_SessionExpiredFailure> get copyWith => __$SessionExpiredFailureCopyWithImpl<_SessionExpiredFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionExpiredFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.sessionExpiredFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$SessionExpiredFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory _$SessionExpiredFailureCopyWith(_SessionExpiredFailure value, $Res Function(_SessionExpiredFailure) _then) = __$SessionExpiredFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$SessionExpiredFailureCopyWithImpl<$Res>
    implements _$SessionExpiredFailureCopyWith<$Res> {
  __$SessionExpiredFailureCopyWithImpl(this._self, this._then);

  final _SessionExpiredFailure _self;
  final $Res Function(_SessionExpiredFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_SessionExpiredFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AIGenerationFailure implements Failure {
  const _AIGenerationFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIGenerationFailureCopyWith<_AIGenerationFailure> get copyWith => __$AIGenerationFailureCopyWithImpl<_AIGenerationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIGenerationFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.aigenerationFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AIGenerationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory _$AIGenerationFailureCopyWith(_AIGenerationFailure value, $Res Function(_AIGenerationFailure) _then) = __$AIGenerationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$AIGenerationFailureCopyWithImpl<$Res>
    implements _$AIGenerationFailureCopyWith<$Res> {
  __$AIGenerationFailureCopyWithImpl(this._self, this._then);

  final _AIGenerationFailure _self;
  final $Res Function(_AIGenerationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_AIGenerationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
