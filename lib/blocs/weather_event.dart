// blocs/weather_event.dart
part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {

  const FetchWeather(this.city);
  final String city;

  @override
  List<Object?> get props => [city];
}
