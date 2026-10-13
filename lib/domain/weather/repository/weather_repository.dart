import 'package:flutter_training/domain/model/result.dart';
import 'package:flutter_training/domain/weather/model/weather_forecast.dart';

abstract interface class WeatherRepository {
  Future<Result<WeatherForecast>> fetchWeatherForecast({
    required String area,
    required DateTime date,
  });
}
