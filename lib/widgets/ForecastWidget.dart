import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class ForecastWidget extends StatelessWidget {
  dynamic forecastData;
  List forecast;
  ForecastWidget(this.forecastData, this.forecast, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: forecast
                  .where((item) => item['dt_txt'].contains('15:00:00'))
                  .length -
              1,
          itemBuilder: (context, index) {
            var item = forecast
                .where((item) => item['dt_txt'].contains('15:00:00'))
                .toList()[index + 1];
            String day = item['dt_txt'];
            DateTime parsedDay = DateTime.parse(day);
            final dayFormat = DateFormat('E');
            return Card(
              color: Colors.transparent,
              elevation: 0,
              child: Column(
                children: [
                  Text(
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                      dayFormat.format(parsedDay)),
                  Image.network(
                    'https://openweathermap.org/img/wn/${item['weather'][0]['icon']}@2x.png',
                    fit: BoxFit.fitWidth,
                    width: 90,
                  ),
                  Text(
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                      '${item['main']['temp'].toStringAsFixed(0)}°C'),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
