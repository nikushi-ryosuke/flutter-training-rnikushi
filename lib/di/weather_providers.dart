import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training/data/api/weather/weather_repository_impl.dart';
import 'package:flutter_training/di/compute_provider.dart';
import 'package:flutter_training/domain/weather/repository/weather_repository.dart';
import 'package:flutter_training/domain/weather/usecase/fetch_weather_use_case.dart';
import 'package:flutter_training/domain/weather/usecase/fetch_weather_use_case_impl.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

final yumemiWeatherProvider = Provider<YumemiWeather>((ref) => YumemiWeather());

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(
    ref.watch(yumemiWeatherProvider),
    ref.watch(computeProvider),
  ),
);

final fetchWeatherUseCaseProvider = Provider<FetchWeatherUseCase>(
  (ref) => FetchWeatherUseCaseImpl(ref.watch(weatherRepositoryProvider)),
);
