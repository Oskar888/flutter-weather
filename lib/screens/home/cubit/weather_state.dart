part of 'weather_cubit.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState.init() = _Init;
  const factory WeatherState.loading() = _Loading;
  const factory WeatherState.loaded(ActualWeatherModel weather, ForecastModel forecast) = _LoadedWeather;
  const factory WeatherState.error(String errorMessage) = _Error;
}
