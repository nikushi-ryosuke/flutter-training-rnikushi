import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/di/compute_provider.dart';
import 'package:flutter_training/di/weather_providers.dart';
import 'package:flutter_training/domain/model/app_error.dart';
import 'package:flutter_training/domain/weather/model/weather_condition.dart';
import 'package:flutter_training/domain/weather/model/weather_forecast.dart';
import 'package:flutter_training/domain/weather/usecase/fetch_weather_use_case.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

import '../../../fake/fake_yumemi_weather.dart';
import '../../../helper/compute_runner.dart';
import '../../../helper/result_matchers.dart';

FetchWeatherUseCase createUseCase(
  YumemiWeather api, {
  ComputeRunner? compute,
}) {
  final container = ProviderContainer.test(
    overrides: [
      yumemiWeatherProvider.overrideWithValue(api),
      if (compute != null) computeProvider.overrideWithValue(compute),
    ],
  );
  return container.read(fetchWeatherUseCaseProvider);
}

void main() {
  group('FetchWeatherUseCaseImpl', () {
    const area = 'tokyo';
    final date = DateTime.utc(2020, 4, 1, 3);

    const successCases = {
      'sunny': WeatherCondition.sunny,
      'cloudy': WeatherCondition.cloudy,
      'rainy': WeatherCondition.rainy,
    };

    for (final MapEntry(key: weather, value: expected)
        in successCases.entries) {
      test('API が "$weather" の天気予報を返すと Success(WeatherForecast) を返す', () async {
        final useCase = createUseCase(
          FakeYumemiWeather.returns(
            weatherResponseJson(weatherCondition: weather),
          ),
        );

        expect(
          await useCase(area: area, date: date),
          isSuccess(
            WeatherForecast(
              condition: expected,
              maxTemperature: 25,
              minTemperature: 7,
              date: DateTime.parse('2020-04-01T12:00:00+09:00'),
            ),
          ),
        );
      });
    }

    test('area と date を JSON にして API を呼び出す', () async {
      final api = FakeYumemiWeather.returns(weatherResponseJson());
      final useCase = createUseCase(api, compute: computeDirectly);

      await useCase(area: area, date: date);

      expect(api.requests.map(jsonDecode), [
        {'area': area, 'date': '2020-04-01T03:00:00.000Z'},
      ]);
    });

    for (final response in ['sunny', '{"weather_condition":', '']) {
      test(
        'API が JSON ではない "$response" を返すと MalformedJsonError を返す',
        () async {
          final useCase = createUseCase(FakeYumemiWeather.returns(response));

          expect(
            await useCase(area: area, date: date),
            isFailure<MalformedJsonError>(),
          );
        },
      );
    }

    final unexpectedResponseCases = {
      '想定外の天気': weatherResponseJson(weatherCondition: 'snowy'),
      'オブジェクトではない JSON': '[]',
      'キーが欠けた JSON': jsonEncode({
        'weather_condition': 'sunny',
        'max_temperature': 25,
      }),
      '型が異なる JSON': jsonEncode({
        'weather_condition': 'sunny',
        'max_temperature': '25',
        'min_temperature': 7,
        'date': '2020-04-01T12:00:00+09:00',
      }),
      '日付として解釈できない JSON': weatherResponseJson(date: 'tomorrow'),
    };

    for (final MapEntry(key: description, value: response)
        in unexpectedResponseCases.entries) {
      test(
        'API が$descriptionを返すと UnexpectedResponseError の Failure を返す',
        () async {
          final useCase = createUseCase(FakeYumemiWeather.returns(response));

          expect(
            await useCase(area: area, date: date),
            isFailure<UnexpectedResponseError>(),
          );
        },
      );
    }

    test(
      'API が invalidParameter を投げると InvalidParameterError の Failure を返す',
      () async {
        final useCase = createUseCase(
          FakeYumemiWeather.throws(YumemiWeatherError.invalidParameter),
        );

        expect(
          await useCase(area: area, date: date),
          isFailure<InvalidParameterError>(),
        );
      },
    );

    test('API が unknown を投げると UnknownError の Failure を返す', () async {
      final useCase = createUseCase(
        FakeYumemiWeather.throws(YumemiWeatherError.unknown),
      );

      expect(await useCase(area: area, date: date), isFailure<UnknownError>());
    });
  });
}
