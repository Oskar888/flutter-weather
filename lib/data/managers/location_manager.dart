import 'package:bloc_example/data/data_providers/location_data_provider.dart';
import 'package:bloc_example/dependency_injection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocationManager {
  final LocationDataProvider _locationDataProvider = getIt<LocationDataProvider>();

  Future<Position> getCurrentLocation() async {
    try {
      return await _locationDataProvider.getCurrentLocation();
    } catch (e) {
      throw Exception(e);
    }
  }
}
