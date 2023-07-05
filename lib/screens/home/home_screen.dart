import 'package:bloc_example/screens/home/cubit/weather_cubit.dart';
import 'package:bloc_example/screens/home/widgets/custom_search_bar.dart';
import 'package:bloc_example/screens/home/widgets/weather_forecast.dart';
import 'package:bloc_example/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.blue1,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorConstants.blue1,
              ColorConstants.blue2,
              ColorConstants.blue3,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomSearchBar(
                controller: searchController,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                return state.when(
                  init: () {
                    return const Text(
                      '<No Data>',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  },
                  loaded: (weatherData, forecastData) {
                    return Column(
                      children: [
                        Text(
                          weatherData.name,
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        ),
                        Image.network(
                          'https://openweathermap.org/img/wn/${weatherData.weather[0].icon}@2x.png',
                        ),
                        Text(
                          '${weatherData.main.temp.toStringAsFixed(0)}°C',
                          style: const TextStyle(
                            fontSize: 46.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: WeatherForecast(
                            nextFiveDaysForecast: forecastData.list.sublist(0, 5 * 8),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (errorMessage) {
                    return AlertDialog(
                      title: const Text('An error has occurred.'),
                      content: Text(errorMessage),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
