import 'dart:core';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import './widgets/ActualWeather.dart';
import './widgets/SearchBar.dart';
import './widgets/ForecastWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeatherApp',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'WeatherApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController cityNameController = TextEditingController();
  String adress = '';
  String? _currentAddress;
  Position? _currentPosition;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        adress = _currentAddress = '${place.subAdministrativeArea}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  static String apiKey = 'YOUR_API_KEY';

  dynamic data;
  String temp = '';
  String city = '';

  Future<void> gettingLiveDataFromApiByGps() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });

    String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${_currentPosition?.latitude}&lon=${_currentPosition?.longitude}&appid=$apiKey&units=metric';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      double temperatura = data['main']['temp'];
      setState(() {
        temp = '${temperatura.toStringAsFixed(0)}°C';
        city = adress;
      });
    } else {
      print('Error gettingLiveDataFromApiByGps');
    }
  }

  Future<void> gettingLiveDataFromApiByCity() async {
    city = cityNameController.text;

    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      double temperatura = data['main']['temp'];
      setState(() {
        temp = '${temperatura.toStringAsFixed(0)}°C';
      });
    } else {
      print('Error gettingLiveDataFromApiByCity');
    }
  }

  late List forecast;
  dynamic forecastData;
  Future gettingForcecastDataFromApi() async {
    String url =
        'http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        forecastData = jsonDecode(response.body);
        forecast = forecastData['list'];
      });
    } else {
      print('Error gettingForcecastDataFromApi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 27, 132, 218),
              Color.fromARGB(255, 57, 143, 213),
              Color.fromARGB(255, 116, 161, 198)
            ])),
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Searchbar(cityNameController, gettingLiveDataFromApiByCity,
                  gettingLiveDataFromApiByGps, gettingForcecastDataFromApi)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: ActualWeather(city, data, temp),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: forecastData != null
                  ? ForecastWidget(forecastData, forecast)
                  : const Text(''))
        ]),
      ),
    );
  }
}
