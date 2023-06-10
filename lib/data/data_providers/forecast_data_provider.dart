import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class ForecastDataProvider {
  Future<dynamic> fetchDataByCity(String cityName) async {
    final response = await Dio().get(
        'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid='YOUR_API_KEY';&units=metric');
    return response;
  }

  Future<dynamic> fetchDataByLocation(Position position) async {
    final response = await Dio().get(
        'http://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid='YOUR_API_KEY';&units=metric');
    return response;
  }
}
