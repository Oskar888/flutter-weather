import 'package:bloc_example/screens/home/cubit/weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (BuildContext context, value, Widget? child) {
          final isEmpty = controller.text.isEmpty;

          return TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              hintText: "Location",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      context.read<WeatherCubit>().fetchDataByLocation();
                    },
                    icon: const Icon(Icons.gps_fixed),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: isEmpty ? Colors.grey : Colors.red,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: (isEmpty == false)
                        ? () {
                            context.read<WeatherCubit>().fetchDataByCity(controller.value.text);
                          }
                        : null,
                    child: const Text("Search"),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
