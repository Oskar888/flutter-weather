import 'dart:convert';

import 'package:bloc_example/data/data_providers/weather_data_provider.dart';
import 'package:bloc_example/dependency_injection.dart';
import 'package:bloc_example/models/actual_weather_model.dart';
import 'package:bloc_example/models/weather_error_model.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WeatherManager {
  final WeatherDataProvider _weatherDataProvider = getIt<WeatherDataProvider>();

  Future<ActualWeatherModel> fetchDataByCity(String cityName) async {
    try {
      final response = await _weatherDataProvider.fetchDataByCity(cityName);
      final responseData = json.decode(response.toString());

      final data = ActualWeatherModel.fromJson(responseData);
      return data;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorResponseData = json.decode(e.response.toString());
        final errorData = WeatherErrorModel.fromJson(errorResponseData);
        throw Exception(errorData.message);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<ActualWeatherModel> fetchDataByLocation(Position position) async {
    try {
      final response = await _weatherDataProvider.fetchDataByLocation(position);
      final responseData = json.decode(response.toString());

      final data = ActualWeatherModel.fromJson(responseData);
      return data;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorResponseData = json.decode(e.response.toString());
        final errorData = WeatherErrorModel.fromJson(errorResponseData);
        throw Exception(errorData.message);
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
