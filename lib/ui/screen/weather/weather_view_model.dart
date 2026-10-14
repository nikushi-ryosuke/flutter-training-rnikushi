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

  Future<void> fetchWeather() async {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);
    final result = await ref.read(fetchWeatherUseCaseProvider)(
      area: _area,
      date: ref.read(clockProvider)(),
    );
    if (!ref.mounted) {
      return;
    }
    state = switch (result) {
      Success(:final value) => state.copyWith(
        weatherForecast: value,
        isLoading: false,
        error: null,
      ),
      Failure(:final error) => state.copyWith(isLoading: false, error: error),
    };
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
