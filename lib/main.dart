import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import './widgets/ActualWeather.dart';
import './widgets/SearchBar.dart';

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

    await http
        .get(Uri.parse(url))
        .then((value) => data = jsonDecode(value.body));

    double temperatura = data['main']['temp'];
    setState(() {
      temp = '${temperatura.toStringAsFixed(0)}°C';
    });
    city = adress;
  }

  Future<void> gettingLiveDataFromApiByCity() async {
    city = cityNameController.text;

    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    await http
        .get(Uri.parse(url))
        .then((value) => data = jsonDecode(value.body));

    double temperatura = data['main']['temp'];
    setState(() {
      temp = '${temperatura.toStringAsFixed(0)}°C';
    });
  }

  Future<void> gettingForcecastDataFromApi() async {
    String url =
        'http://api.openweathermap.org/data/2.5/forecast?lat=${_currentPosition?.latitude}&lon=${_currentPosition?.longitude}&appid=$apiKey&units=metric';

    await http
        .get(Uri.parse(url))
        .then((value) => data = jsonDecode(value.body));

    double temperatura = data['main']['temp'];
    setState(() {
      temp = '${temperatura.toStringAsFixed(0)}°C';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 32, 131, 211),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Searchbar(cityNameController, gettingLiveDataFromApiByCity,
                  gettingLiveDataFromApiByGps)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            child: ActualWeather(city, data, temp),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
        ],
      ),
    );
  }
}
