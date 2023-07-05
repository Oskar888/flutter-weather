// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'data/data_providers/forecast_data_provider.dart' as _i3;
import 'data/data_providers/location_data_provider.dart' as _i5;
import 'data/data_providers/weather_data_provider.dart' as _i7;
import 'data/managers/forecast_manager.dart' as _i4;
import 'data/managers/location_manager.dart' as _i6;
import 'data/managers/weather_manager.dart' as _i8;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.ForecastDataProvider>(
        () => _i3.ForecastDataProvider());
    gh.lazySingleton<_i4.ForecastManager>(() => _i4.ForecastManager());
    gh.lazySingleton<_i5.LocationDataProvider>(
        () => _i5.LocationDataProvider());
    gh.lazySingleton<_i6.LocationManager>(() => _i6.LocationManager());
    gh.lazySingleton<_i7.WeatherDataProvider>(() => _i7.WeatherDataProvider());
    gh.lazySingleton<_i8.WeatherManager>(() => _i8.WeatherManager());
    return this;
  }
}
