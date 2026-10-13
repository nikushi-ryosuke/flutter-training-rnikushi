import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/data/api/weather/dto/weather_request.dart';

void main() {
  group('WeatherRequest', () {
    final cases = {
      'UTC': (DateTime.utc(2020, 4, 1, 3), '2020-04-01T03:00:00.000Z'),
      'ローカル時刻': (DateTime(2020, 4, 1, 12), '2020-04-01T12:00:00.000'),
    };

    for (final MapEntry(key: description, value: (date, expected))
        in cases.entries) {
      test('toJson で area と$descriptionの date を ISO 8601 の文字列にする', () {
        expect(WeatherRequest(area: 'tokyo', date: date).toJson(), {
          'area': 'tokyo',
          'date': expected,
        });
      });
    }
  });
}
