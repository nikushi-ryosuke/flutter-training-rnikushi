import 'dart:convert';

import 'package:flutter_training/data/api/compute_runner.dart';
import 'package:flutter_training/data/api/weather/dto/weather_request.dart';
import 'package:flutter_training/data/api/weather/dto/weather_response.dart';
import 'package:flutter_training/domain/model/app_error.dart';
import 'package:flutter_training/domain/model/result.dart';
import 'package:flutter_training/domain/weather/model/weather_forecast.dart';
import 'package:flutter_training/domain/weather/repository/weather_repository.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl(this._api, this._compute);

  final YumemiWeather _api;

  final ComputeRunner _compute;

  @override
  Future<Result<WeatherForecast>> fetchWeatherForecast({
    required String area,
    required DateTime date,
  }) async {
    final request = jsonEncode(WeatherRequest(area: area, date: date).toJson());
    try {
      final response = await _compute(_api.syncFetchWeather, request);
      return switch (jsonDecode(response)) {
        final Map<String, dynamic> json => Success(
          WeatherResponse.fromJson(json).toWeatherForecast(),
        ),
        _ => const Failure(UnexpectedResponseError()),
      };
    } on YumemiWeatherError catch (error) {
      return Failure(switch (error) {
        YumemiWeatherError.invalidParameter => const InvalidParameterError(),
        YumemiWeatherError.unknown => const UnknownError(),
      });
    } on FormatException {
      return const Failure(MalformedJsonError());
    } on CheckedFromJsonException {
      return const Failure(UnexpectedResponseError());
    }
  }
}
