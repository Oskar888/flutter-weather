import 'package:bloc_example/data/data_providers/location_data_provider.dart';
import 'package:geolocator/geolocator.dart';

class LocationManager {
  final LocationDataProvider _locationDataProvider;

  LocationManager(
    this._locationDataProvider,
  );

  Future<Position> getCurrentLocation() async {
    try {
      await _checkLocationPermission();

      return await _locationDataProvider.getCurrentLocation();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }
}
