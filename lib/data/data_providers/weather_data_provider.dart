import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class WeatherDataProvider {
  Future<dynamic> fetchDataByCity(String cityName) async {
    final response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid='YOUR_API_KEY';&units=metric');
    return response;
  }

  Future<dynamic> fetchDataByLocation(Position position) async {
    final response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid='YOUR_API_KEY';&units=metric');
    return response;
  }
}
