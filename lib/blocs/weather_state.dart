// blocs/weather_state.dart
part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {

  const WeatherLoaded({required this.weatherData, required this.forecastData});
  final Map<String, dynamic> weatherData;
  final Map<String, dynamic> forecastData;

  @override
  List<Object?> get props => [weatherData, forecastData];
}

class WeatherError extends WeatherState {

  const WeatherError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
