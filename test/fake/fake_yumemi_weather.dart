import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

String weatherResponseJson({
  String weatherCondition = 'sunny',
  int maxTemperature = 25,
  int minTemperature = 7,
  String date = '2020-04-01T12:00:00+09:00',
}) => jsonEncode({
  'weather_condition': weatherCondition,
  'max_temperature': maxTemperature,
  'min_temperature': minTemperature,
  'date': date,
});

class FakeYumemiWeather extends Fake implements YumemiWeather {
  FakeYumemiWeather.returns(String response) : _responses = [() => response];

  FakeYumemiWeather.throws(YumemiWeatherError error)
    : _responses = [() => _throw(error)];

  FakeYumemiWeather.returnsThenThrows(
    String response,
    YumemiWeatherError error,
  ) : _responses = [() => response, () => _throw(error)];

  final List<String Function()> _responses;

  final List<String> _requests = [];

  var _callCount = 0;

  List<String> get requests => List.unmodifiable(_requests);

  @override
  String syncFetchWeather(String jsonString) {
    _requests.add(jsonString);
    final response = _responses[min(_callCount, _responses.length - 1)];
    _callCount++;
    return response();
  }

  static String _throw(YumemiWeatherError error) =>
      Error.throwWithStackTrace(error, StackTrace.current);
}
