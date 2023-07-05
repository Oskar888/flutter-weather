import 'package:bloc_example/data/data_providers/location_data_provider.dart';
import 'package:bloc_example/dependency_injection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocationManager {
  final LocationDataProvider _locationDataProvider = getIt<LocationDataProvider>();

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
