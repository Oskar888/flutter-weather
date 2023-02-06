import 'package:http/http.dart' as http;
import '../models/weather_city.dart';
import '../models/weather_gps.dart';

class RemoteService {
  Future<WeatherByCity?> getByCity(String apiKey, String city) async {
    var client = http.Client();

    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var json = response.body; //it is JSON string from API
      return weatherByCityFromJson(json); //parse JSON using our model
    }
    return null;
  }

  Future<WeatherByGps?> getByGps(String apiKey, double lat, double long) async {
    var client = http.Client();

    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var json = response.body; //it is JSON string from API
      return weatherByGpsFromJson(json); //parse JSON using our model
    }
    return null;
  }
}
