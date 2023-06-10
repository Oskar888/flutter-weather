import 'package:bloc_example/models/actual_weather_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_example/data/managers/forecast_manager.dart';
import 'package:bloc_example/data/managers/location_manager.dart';
import 'package:bloc_example/data/managers/weather_manager.dart';
import 'package:bloc_example/models/forecast_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_state.dart';
part 'weather_cubit.freezed.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(
    this._weatherManager,
    this._forecastManager,
    this._locationManager,
  ) : super(const WeatherState.init());

  final WeatherManager _weatherManager;
  final ForecastManager _forecastManager;
  final LocationManager _locationManager;

  Future<void> fetchDataByCity(String cityName) async {
    emit(
      const WeatherState.loading(),
    );

    try {
      final responseWeather = await _weatherManager.fetchDataByCity(cityName);
      final responseForecast = await _forecastManager.fetchDataByCity(cityName);
      emit(
        WeatherState.loaded(responseWeather, responseForecast),
      );
    } catch (e) {
      emit(
        WeatherState.error(e.toString()),
      );
    }
  }

  Future<void> fetchDataByLocation() async {
    emit(
      const WeatherState.loading(),
    );

    try {
      final position = await _locationManager.getCurrentLocation();
      final responseWeather = await _weatherManager.fetchDataByLocation(position);
      final responseForecast = await _forecastManager.fetchDataByLocation(position);

      emit(
        WeatherState.loaded(responseWeather, responseForecast),
      );
    } catch (e) {
      emit(
        WeatherState.error(e.toString()),
      );
    }
  }
}
