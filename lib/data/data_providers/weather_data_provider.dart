import 'package:bloc_example/utils/api_key.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WeatherDataProvider {
  Future<dynamic> fetchDataByCity(String cityName) async {
    final response =
        await Dio().get('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');

    return response;
  }

  Future<dynamic> fetchDataByLocation(Position position) async {
    final response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric');

    return response;
  }
}
