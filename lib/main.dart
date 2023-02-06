import 'dart:core';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/pages/home.dart';

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
      home: const Home(title: 'WeatherApp'),
    );
  }
}
