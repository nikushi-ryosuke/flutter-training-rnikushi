import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/di/compute_provider.dart';
import 'package:flutter_training/di/weather_providers.dart';
import 'package:flutter_training/ui/screen/weather/weather_screen.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

import '../../../fake/fake_yumemi_weather.dart';
import '../../../helper/compute_runner.dart';

Future<void> pumpWeatherScreen(
  WidgetTester tester,
  YumemiWeather api, {
  ComputeRunner compute = computeDirectly,
}) {
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        yumemiWeatherProvider.overrideWithValue(api),
        computeProvider.overrideWithValue(compute),
      ],
      child: const MaterialApp(home: WeatherScreen()),
    ),
  );
}

Future<void> tapReload(WidgetTester tester) async {
  await tester.tap(find.text('Reload'));
  await tester.pumpAndSettle();
}

void main() {
  group('WeatherScreen', () {
    const unknownMessage = '天気を取得できませんでした。時間をおいて再度お試しください。';

    testWidgets('API が unknown を投げるとエラーダイアログを表示する', (tester) async {
      await pumpWeatherScreen(
        tester,
        FakeYumemiWeather.throws(YumemiWeatherError.unknown),
      );

      await tapReload(tester);

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(unknownMessage), findsOneWidget);
    });

    testWidgets(
      'API が invalidParameter を投げると取得条件のエラーメッセージを表示する',
      (tester) async {
        await pumpWeatherScreen(
          tester,
          FakeYumemiWeather.throws(YumemiWeatherError.invalidParameter),
        );

        await tapReload(tester);

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('天気の取得条件が正しくありません。'), findsOneWidget);
      },
    );

    testWidgets('OK で閉じた後も、再度エラーになるとダイアログを表示する', (tester) async {
      await pumpWeatherScreen(
        tester,
        FakeYumemiWeather.throws(YumemiWeatherError.unknown),
      );

      await tapReload(tester);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);

      await tapReload(tester);

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('ダイアログの外側をタップして閉じた後も、再度エラーになるとダイアログを表示する', (
      tester,
    ) async {
      await pumpWeatherScreen(
        tester,
        FakeYumemiWeather.throws(YumemiWeatherError.unknown),
      );

      await tapReload(tester);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);

      await tapReload(tester);

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('取得に失敗しても、表示中の天気を残す', (tester) async {
      await pumpWeatherScreen(
        tester,
        FakeYumemiWeather.returnsThenThrows(
          weatherResponseJson(),
          YumemiWeatherError.unknown,
        ),
      );

      await tapReload(tester);

      expect(find.byType(SvgPicture), findsOneWidget);

      await tapReload(tester);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);
    });

    testWidgets('取得に成功するとダイアログを表示しない', (tester) async {
      await pumpWeatherScreen(
        tester,
        FakeYumemiWeather.returns(weatherResponseJson()),
      );

      await tapReload(tester);

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('取得前は気温を ** ℃ で表示する', (tester) async {
      await pumpWeatherScreen(
        tester,
        FakeYumemiWeather.returns(weatherResponseJson()),
      );

      expect(find.text('** ℃'), findsNWidgets(2));
    });

    testWidgets('取得に成功すると最低気温と最高気温を表示する', (tester) async {
      await pumpWeatherScreen(
        tester,
        FakeYumemiWeather.returns(
          weatherResponseJson(minTemperature: -3, maxTemperature: 12),
        ),
      );

      await tapReload(tester);

      expect(find.text('-3 ℃'), findsOneWidget);
      expect(find.text('12 ℃'), findsOneWidget);
      expect(find.text('** ℃'), findsNothing);
    });
  });
}
