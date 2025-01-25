// blocs/weather_bloc.dart


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

        final lastUpdated = weatherRepository.getLastUpdated();
        emit(
          WeatherLoaded(
            weatherData: weatherData,
            forecastData: forecastData,
            lastUpdated: lastUpdated,
          ),
        );
      } catch (e) {
        emit(WeatherError(message: e.toString()));
      }
    });
  }

  final WeatherRepository weatherRepository;
}
