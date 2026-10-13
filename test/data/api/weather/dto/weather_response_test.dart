import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/data/api/weather/dto/weather_response.dart';
import 'package:flutter_training/domain/weather/model/weather_condition.dart';
import 'package:flutter_training/domain/weather/model/weather_forecast.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../fake/fake_yumemi_weather.dart';

Map<String, dynamic> decode(String json) =>
    jsonDecode(json) as Map<String, dynamic>;

void main() {
  group('WeatherResponse', () {
    test('fromJson で snake_case のキーを各フィールドに変換する', () {
      expect(
        WeatherResponse.fromJson(
          decode(
            weatherResponseJson(
              weatherCondition: 'rainy',
              maxTemperature: 12,
              minTemperature: -3,
            ),
          ),
        ),
        WeatherResponse(
          weatherCondition: WeatherCondition.rainy,
          maxTemperature: 12,
          minTemperature: -3,
          date: DateTime.parse('2020-04-01T12:00:00+09:00'),
        ),
      );
    });

    for (final condition in WeatherCondition.values) {
      test('fromJson で "${condition.name}" を WeatherCondition に変換する', () {
        expect(
          WeatherResponse.fromJson(
            decode(weatherResponseJson(weatherCondition: condition.name)),
          ).weatherCondition,
          condition,
        );
      });
    }

    test('fromJson でタイムゾーン付きの date を同じ時刻の DateTime に変換する', () {
      expect(
        WeatherResponse.fromJson(decode(weatherResponseJson())).date,
        DateTime.utc(2020, 4, 1, 3),
      );
    });

    final invalidCases = <String, Map<String, dynamic>>{
      '想定外の天気': decode(weatherResponseJson(weatherCondition: 'snowy')),
      for (final key in decode(weatherResponseJson()).keys)
        '$key の欠落': decode(weatherResponseJson())..remove(key),
      '型の不一致': {
        ...decode(weatherResponseJson()),
        'max_temperature': '25',
      },
      '日付として解釈できない date': decode(weatherResponseJson(date: 'tomorrow')),
    };

    for (final MapEntry(key: description, value: json)
        in invalidCases.entries) {
      test('fromJson は$descriptionで CheckedFromJsonException を投げる', () {
        expect(
          () => WeatherResponse.fromJson(json),
          throwsA(isA<CheckedFromJsonException>()),
        );
      });
    }

    test('toWeatherForecast で Domain Model に変換する', () {
      final date = DateTime.parse('2020-04-01T12:00:00+09:00');

      expect(
        WeatherResponse(
          weatherCondition: WeatherCondition.cloudy,
          maxTemperature: 25,
          minTemperature: 7,
          date: date,
        ).toWeatherForecast(),
        WeatherForecast(
          condition: WeatherCondition.cloudy,
          maxTemperature: 25,
          minTemperature: 7,
          date: date,
        ),
      );
    });
  });
}
