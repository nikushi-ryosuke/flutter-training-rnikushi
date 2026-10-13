import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/di/clock_provider.dart';
import 'package:flutter_training/di/weather_providers.dart';
import 'package:flutter_training/domain/model/app_error.dart';
import 'package:flutter_training/domain/weather/model/weather_condition.dart';
import 'package:flutter_training/domain/weather/model/weather_forecast.dart';
import 'package:flutter_training/ui/screen/weather/weather_ui_state.dart';
import 'package:flutter_training/ui/screen/weather/weather_view_model.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

import '../../../fake/fake_yumemi_weather.dart';

final now = DateTime.utc(2020, 4, 1, 3);

final forecast = WeatherForecast(
  condition: WeatherCondition.sunny,
  maxTemperature: 25,
  minTemperature: 7,
  date: DateTime.parse('2020-04-01T12:00:00+09:00'),
);

ProviderContainer createContainer(YumemiWeather api) => ProviderContainer.test(
  overrides: [
    yumemiWeatherProvider.overrideWithValue(api),
    clockProvider.overrideWithValue(() => now),
  ],
);

List<WeatherUiState> listenStates(ProviderContainer container) {
  final states = <WeatherUiState>[];
  container.listen(
    weatherViewModelProvider,
    (_, next) => states.add(next),
    fireImmediately: true,
  );
  return states;
}

Matcher isWeatherUiState({
  required Object? weatherForecast,
  required Object? error,
}) => isA<WeatherUiState>()
    .having((s) => s.weatherForecast, 'weatherForecast', weatherForecast)
    .having((s) => s.error, 'error', error);

void main() {
  group('WeatherViewModel', () {
    test('初期状態は天気予報もエラーも持たない', () {
      final container = createContainer(
        FakeYumemiWeather.returns(weatherResponseJson()),
      );

      expect(listenStates(container), [
        isWeatherUiState(weatherForecast: isNull, error: isNull),
      ]);
    });

    test('取得に成功すると、天気予報を持つ状態を通知する', () {
      final container = createContainer(
        FakeYumemiWeather.returns(weatherResponseJson()),
      );
      final states = listenStates(container);

      container.read(weatherViewModelProvider.notifier).fetchWeather();

      expect(states, [
        isWeatherUiState(weatherForecast: isNull, error: isNull),
        isWeatherUiState(weatherForecast: forecast, error: isNull),
      ]);
    });

    test('tokyo と現在時刻で天気を取得する', () {
      final api = FakeYumemiWeather.returns(weatherResponseJson());
      final container = createContainer(api);
      listenStates(container);

      container.read(weatherViewModelProvider.notifier).fetchWeather();

      expect(api.requests.map(jsonDecode), [
        {'area': 'tokyo', 'date': '2020-04-01T03:00:00.000Z'},
      ]);
    });

    final failureCases = {
      'API が invalidParameter を投げる': (
        FakeYumemiWeather.throws(YumemiWeatherError.invalidParameter),
        isA<InvalidParameterError>(),
      ),
      'API が unknown を投げる': (
        FakeYumemiWeather.throws(YumemiWeatherError.unknown),
        isA<UnknownError>(),
      ),
      'API が JSON ではない文字列を返す': (
        FakeYumemiWeather.returns('sunny'),
        isA<MalformedJsonError>(),
      ),
      'API が期待する形式ではない JSON を返す': (
        FakeYumemiWeather.returns('[]'),
        isA<UnexpectedResponseError>(),
      ),
    };

    for (final MapEntry(key: description, value: (api, error))
        in failureCases.entries) {
      test('$descriptionと、エラーを持つ状態を通知する', () {
        final container = createContainer(api);
        final states = listenStates(container);

        container.read(weatherViewModelProvider.notifier).fetchWeather();

        expect(states, [
          isWeatherUiState(weatherForecast: isNull, error: isNull),
          isWeatherUiState(weatherForecast: isNull, error: error),
        ]);
      });
    }

    test('成功の後に失敗すると、表示中の天気予報を残したままエラーを持つ', () {
      final container = createContainer(
        FakeYumemiWeather.returnsThenThrows(
          weatherResponseJson(),
          YumemiWeatherError.unknown,
        ),
      );
      final states = listenStates(container);
      final viewModel = container.read(weatherViewModelProvider.notifier);

      viewModel
        ..fetchWeather()
        ..fetchWeather();

      expect(states, [
        isWeatherUiState(weatherForecast: isNull, error: isNull),
        isWeatherUiState(weatherForecast: forecast, error: isNull),
        isWeatherUiState(weatherForecast: forecast, error: isA<UnknownError>()),
      ]);
    });

    test('clearError で、天気予報を残したままエラーだけを消す', () {
      final container = createContainer(
        FakeYumemiWeather.returnsThenThrows(
          weatherResponseJson(),
          YumemiWeatherError.unknown,
        ),
      );
      final states = listenStates(container);

      container.read(weatherViewModelProvider.notifier)
        ..fetchWeather()
        ..fetchWeather()
        ..clearError();

      expect(states, [
        isWeatherUiState(weatherForecast: isNull, error: isNull),
        isWeatherUiState(weatherForecast: forecast, error: isNull),
        isWeatherUiState(weatherForecast: forecast, error: isA<UnknownError>()),
        isWeatherUiState(weatherForecast: forecast, error: isNull),
      ]);
    });
  });
}
