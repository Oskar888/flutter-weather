import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../services/models/weather_city.dart';
import '../services/models/weather_gps.dart';
import '../services/backend/remote_services.dart';
import '../widgets/actual_weather.dart';
import '../widgets/search_bar.dart';
import '../widgets/forecast_widget.dart';
import '../services/settings/location_permission.dart';
import '../utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void dispose() {
    cityNameController;
    super.dispose();
  }

  static String apiKey = 'YOUR_API_KEY';
  bool isLoaded = false;
  TextEditingController cityNameController = TextEditingController();
  WeatherByCity? byCity;
  WeatherByGps? byGps;
  String temp = '';
  String city = '';
  String adress = '';
  dynamic icon;
  late String currentAddress;
  late Position _currentPosition;

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition.latitude, _currentPosition.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        adress = currentAddress = '${place.subAdministrativeArea}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  _getGpsData() async {
    final hasPermission = await handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _getWeatherByCity() async {
    byCity = await RemoteService().getByCity(apiKey, cityNameController.text);
    if (byCity != null) {
      setState(() {
        city = cityNameController.text;
        temp = '${byCity!.main.temp.toStringAsFixed(0)}°C';
        isLoaded = true;
        icon = byCity!.weather[0].icon;
      });
    }
  }

  void _getWeatherByGps() async {
    await _getGpsData();

    byGps = await RemoteService().getByGps(
        apiKey, _currentPosition.latitude, _currentPosition.longitude);
    if (byGps != null) {
      setState(() {
        city = adress;
        temp = '${byGps!.main.temp.toStringAsFixed(0)}°C';
        isLoaded = true;
        icon = byGps!.weather[0].icon;
      });
    }
  }

  late List forecast;
  dynamic forecastData;
  Future _gettingForcecastDataFromApi() async {
    String url =
        'http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        forecastData = jsonDecode(response.body);
        forecast = forecastData['list'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              ColorConstants.blue1,
              ColorConstants.blue2,
              ColorConstants.blue3,
            ])),
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Searchbar(cityNameController, _getWeatherByCity,
                  _getWeatherByGps, _gettingForcecastDataFromApi)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: ActualWeather(city, icon, temp),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child:
                  forecastData != null ? ForecastWidget(forecast) : Container())
        ]),
      ),
    );
  }
}
