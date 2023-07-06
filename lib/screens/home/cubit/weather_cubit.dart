import 'dart:async';

import 'package:bloc_example/dependency_injection.dart';
import 'package:bloc_example/models/actual_weather_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_example/data/managers/forecast_manager.dart';
import 'package:bloc_example/data/managers/location_manager.dart';
import 'package:bloc_example/data/managers/weather_manager.dart';
import 'package:bloc_example/models/forecast_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'weather_state.dart';
part 'weather_cubit.freezed.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(const WeatherState.init());

  final WeatherManager _weatherManager = getIt<WeatherManager>();
  final ForecastManager _forecastManager = getIt<ForecastManager>();
  final LocationManager _locationManager = getIt<LocationManager>();

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
      await _checkLocationPermission();
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

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }
}
