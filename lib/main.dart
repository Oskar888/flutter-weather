import 'package:bloc_example/data/data_providers/forecast_data_provider.dart';
import 'package:bloc_example/data/data_providers/location_data_provider.dart';
import 'package:bloc_example/data/data_providers/weather_data_provider.dart';
import 'package:bloc_example/data/managers/forecast_manager.dart';
import 'package:bloc_example/data/managers/location_manager.dart';
import 'package:bloc_example/data/managers/weather_manager.dart';
import 'package:bloc_example/screens/home/cubit/weather_cubit.dart';
import 'package:bloc_example/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(
        WeatherManager(WeatherDataProvider()),
        ForecastManager(ForecastDataProvider()),
        LocationManager(LocationDataProvider()),
      )..fetchDataByLocation(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
