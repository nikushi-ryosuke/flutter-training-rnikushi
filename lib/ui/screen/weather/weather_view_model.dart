import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training/di/clock_provider.dart';
import 'package:flutter_training/di/weather_providers.dart';
import 'package:flutter_training/domain/model/result.dart';
import 'package:flutter_training/ui/screen/weather/weather_ui_state.dart';

final NotifierProvider<WeatherViewModel, WeatherUiState>
weatherViewModelProvider = NotifierProvider.autoDispose(WeatherViewModel.new);

class WeatherViewModel extends Notifier<WeatherUiState> {
  static const _area = 'tokyo';

  @override
  WeatherUiState build() => const WeatherUiState();

  void fetchWeather() {
    final result = ref.read(fetchWeatherUseCaseProvider)(
      area: _area,
      date: ref.read(clockProvider)(),
    );
    state = switch (result) {
      Success(:final value) => WeatherUiState(weatherForecast: value),
      Failure(:final error) => WeatherUiState(
        weatherForecast: state.weatherForecast,
        error: error,
      ),
    };
  }

  void clearError() {
    state = WeatherUiState(weatherForecast: state.weatherForecast);
  }
}
