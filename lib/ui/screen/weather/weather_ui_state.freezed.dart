// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherUiState {

 WeatherForecast? get weatherForecast; AppError? get error;
/// Create a copy of WeatherUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherUiStateCopyWith<WeatherUiState> get copyWith => _$WeatherUiStateCopyWithImpl<WeatherUiState>(this as WeatherUiState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeatherUiState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherUiState&&(identical(other.weatherForecast, _this.weatherForecast) || other.weatherForecast == _this.weatherForecast)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as WeatherUiState;
  return Object.hash(runtimeType,_this.weatherForecast,_this.error);
}

@override
String toString() {
  final _this = this as WeatherUiState;
  return 'WeatherUiState(weatherForecast: ${_this.weatherForecast}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $WeatherUiStateCopyWith<$Res>  {
  factory $WeatherUiStateCopyWith(WeatherUiState value, $Res Function(WeatherUiState) _then) = _$WeatherUiStateCopyWithImpl;
@useResult
$Res call({
 WeatherForecast? weatherForecast, AppError? error
});


$WeatherForecastCopyWith<$Res>? get weatherForecast;

}
/// @nodoc
class _$WeatherUiStateCopyWithImpl<$Res>
    implements $WeatherUiStateCopyWith<$Res> {
  _$WeatherUiStateCopyWithImpl(this._self, this._then);

  final WeatherUiState _self;
  final $Res Function(WeatherUiState) _then;

/// Create a copy of WeatherUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weatherForecast = freezed,Object? error = freezed,}) {
  return _then(WeatherUiState(
weatherForecast: freezed == weatherForecast ? _self.weatherForecast : weatherForecast // ignore: cast_nullable_to_non_nullable
as WeatherForecast?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}
/// Create a copy of WeatherUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherForecastCopyWith<$Res>? get weatherForecast {
    if (_self.weatherForecast == null) {
    return null;
  }

  return $WeatherForecastCopyWith<$Res>(_self.weatherForecast!, (value) {
    return _then(_self.copyWith(weatherForecast: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeatherUiState].
extension WeatherUiStatePatterns on WeatherUiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherUiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherUiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherUiState value)  $default,){
final _that = this;
switch (_that) {
case _WeatherUiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherUiState value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherUiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeatherForecast? weatherForecast,  AppError? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherUiState() when $default != null:
return $default(_that.weatherForecast,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeatherForecast? weatherForecast,  AppError? error)  $default,) {final _that = this;
switch (_that) {
case _WeatherUiState():
return $default(_that.weatherForecast,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeatherForecast? weatherForecast,  AppError? error)?  $default,) {final _that = this;
switch (_that) {
case _WeatherUiState() when $default != null:
return $default(_that.weatherForecast,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherUiState implements WeatherUiState {
  const _WeatherUiState({this.weatherForecast, this.error});
  

@override final  WeatherForecast? weatherForecast;
@override final  AppError? error;

/// Create a copy of WeatherUiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherUiStateCopyWith<_WeatherUiState> get copyWith => __$WeatherUiStateCopyWithImpl<_WeatherUiState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherUiState&&(identical(other.weatherForecast, weatherForecast) || other.weatherForecast == weatherForecast)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weatherForecast,error);
}

@override
String toString() {
    return 'WeatherUiState(weatherForecast: $weatherForecast, error: $error)';
}


}

/// @nodoc
abstract mixin class _$WeatherUiStateCopyWith<$Res> implements $WeatherUiStateCopyWith<$Res> {
  factory _$WeatherUiStateCopyWith(_WeatherUiState value, $Res Function(_WeatherUiState) _then) = __$WeatherUiStateCopyWithImpl;
@override @useResult
$Res call({
 WeatherForecast? weatherForecast, AppError? error
});


@override $WeatherForecastCopyWith<$Res>? get weatherForecast;

}
/// @nodoc
class __$WeatherUiStateCopyWithImpl<$Res>
    implements _$WeatherUiStateCopyWith<$Res> {
  __$WeatherUiStateCopyWithImpl(this._self, this._then);

  final _WeatherUiState _self;
  final $Res Function(_WeatherUiState) _then;

/// Create a copy of WeatherUiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weatherForecast = freezed,Object? error = freezed,}) {
  return _then(_WeatherUiState(
weatherForecast: freezed == weatherForecast ? _self.weatherForecast : weatherForecast // ignore: cast_nullable_to_non_nullable
as WeatherForecast?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}

/// Create a copy of WeatherUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherForecastCopyWith<$Res>? get weatherForecast {
    if (_self.weatherForecast == null) {
    return null;
  }

  return $WeatherForecastCopyWith<$Res>(_self.weatherForecast!, (value) {
    return _then(_self.copyWith(weatherForecast: value));
  });
}
}

// dart format on
