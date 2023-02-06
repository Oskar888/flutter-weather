import 'package:flutter/material.dart';

class ActualWeather extends StatelessWidget {
  final String currentAddress;
  final dynamic icon;
  final String temp;

  const ActualWeather(this.currentAddress, this.icon, this.temp, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.1,
                color: Colors.white),
            currentAddress),
        Container(
          child: icon == null
              ? const Text('')
              : Image.network(
                  'https://openweathermap.org/img/wn/$icon@2x.png',
                ),
        ),
        const SizedBox(height: 20),
        Text(
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.12,
                color: Colors.white),
            temp),
      ],
    );
  }
}
