import 'package:flutter/material.dart';

class ActualWeather extends StatelessWidget {
  String currentAddress = '';
  dynamic data;
  String temp;

  ActualWeather(this.currentAddress, this.data, this.temp, {super.key});

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
          child: data == null
              ? const Text('')
              : Image.network(
                  'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png',
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
