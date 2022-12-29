import 'package:flutter/material.dart';
import './SearchBar.dart';

class ActualWeather extends StatelessWidget {
  String? currentAddress;
  dynamic data;
  String temp;

  ActualWeather(this.currentAddress, this.data, this.temp, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
            style: const TextStyle(fontSize: 40, color: Colors.white),
            currentAddress ?? ''),
        Container(
          child: data == null
              ? const Text('')
              : Image.network(
                  'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png',
                ),
        ),
        const SizedBox(height: 20),
        Text(style: const TextStyle(fontSize: 45, color: Colors.white), temp),
        const SizedBox(height: 20),
      ],
    );
  }
}
