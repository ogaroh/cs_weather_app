// blocs/weather_bloc.dart

import 'dart:io';

import 'package:assessment/weather/services/weather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weatherData =
            await weatherRepository.fetchCurrentWeather(event.city);
        final forecastData =
            await weatherRepository.fetchWeatherForecast(event.city);
        emit(
          WeatherLoaded(
            weatherData: weatherData,
            forecastData: forecastData,
          ),
        );
      } on SocketException {
        emit(
          const WeatherError(
            message: 'No internet connection. Please check your network.',
          ),
        );
      } on Exception catch (e) {
        emit(
          WeatherError(
            message: e.toString().replaceAll(
                  'Exception: ',
                  '',
                ),
          ),
        );
      }
    });
  }

  final WeatherRepository weatherRepository;
}
