import 'dart:convert';

import 'package:bloc_example/data/data_providers/forecast_data_provider.dart';
import 'package:bloc_example/dependency_injection.dart';
import 'package:bloc_example/models/forecast_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ForecastManager {
  final ForecastDataProvider _forecastDataProvider = getIt<ForecastDataProvider>();

  Future<ForecastModel> fetchDataByCity(String cityName) async {
    try {
      final response = await _forecastDataProvider.fetchDataByCity(cityName);
      final responseData = json.decode(response.toString());

      final data = ForecastModel.fromJson(responseData);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ForecastModel> fetchDataByLocation(Position position) async {
    try {
      final response = await _forecastDataProvider.fetchDataByLocation(position);
      final responseData = json.decode(response.toString());

      final data = ForecastModel.fromJson(responseData);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
