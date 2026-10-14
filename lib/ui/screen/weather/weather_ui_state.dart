import 'package:flutter_training/domain/model/app_error.dart';
import 'package:flutter_training/domain/weather/model/weather_forecast.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_ui_state.freezed.dart';

@freezed
abstract class WeatherUiState with _$WeatherUiState {
  const factory WeatherUiState({
    WeatherForecast? weatherForecast,
    AppError? error,
    @Default(false) bool isLoading,
  }) = _WeatherUiState;
}
