import 'package:bloc_example/models/forecast_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherForecast extends StatelessWidget {
  const WeatherForecast({Key? key, required this.nextFiveDaysForecast}) : super(key: key);

  final List<ListElement> nextFiveDaysForecast;

  @override
  Widget build(BuildContext context) {
    final forecastList = _groupForecastByDay(nextFiveDaysForecast);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: forecastList.length - 1,
      itemBuilder: (context, index) {
        final forecastDate = forecastList[index + 1].first.dtTxt;
        final weatherIcon = forecastList[index + 1].first.weather.first.icon;
        final temperature = forecastList[index + 1].first.main.temp;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('E').format(forecastDate), // Customize the date format if needed
              style: TextStyle(
                  color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 5),
            Image.network(
              'https://openweathermap.org/img/wn/$weatherIcon@2x.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 0.22,
            ),
            Text(
              '${temperature.toStringAsFixed(0)}°C',
              style: TextStyle(
                  color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.w300),
            ),
          ],
        );
      },
    );
  }

  List<List<ListElement>> _groupForecastByDay(List<ListElement> forecastList) {
    final groupedForecast = <List<ListElement>>[];
    DateTime? currentDay;

    for (final forecast in forecastList) {
      // Check if the forecast time is 12:00 hours
      if (forecast.dtTxt.hour == 12) {
        final forecastDay = DateTime(forecast.dtTxt.year, forecast.dtTxt.month, forecast.dtTxt.day);

        if (currentDay == null || currentDay != forecastDay) {
          currentDay = forecastDay;
          groupedForecast.add([forecast]);
        } else {
          groupedForecast.last.add(forecast);
        }
      }
    }

    return groupedForecast;
  }
}
