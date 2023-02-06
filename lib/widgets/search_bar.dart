import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  final TextEditingController controller;
  final dynamic searchByCity;
  final Function searchByGps;
  final dynamic forecastData;

  const Searchbar(
      this.controller, this.searchByCity, this.searchByGps, this.forecastData,
      {super.key});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  bool isButtonActive = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      isButtonActive = widget.controller.text.isNotEmpty;
      setState(() => isButtonActive = isButtonActive);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: widget.controller,
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
                    onPressed: () async {
                      await widget.searchByGps();
                      widget.forecastData();
                    },
                    icon: const Icon(Icons.gps_fixed)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                    backgroundColor: Colors.red,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                  ),
                  onPressed: isButtonActive
                      ? () async {
                          await widget.searchByCity();
                          widget.forecastData();
                        }
                      : null,
                  child: const Text("Search"),
                ),
                const SizedBox(
                  width: 4,
                ),
              ]),
        ),
      ),
    );
  }
}
