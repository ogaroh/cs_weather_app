// blocs/weather_bloc.dart
import 'package:assessment/services/weather_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
        emit(WeatherLoaded(
            weatherData: weatherData, forecastData: forecastData,),);
      } catch (e) {
        emit(const WeatherError(message: 'Could not fetch weather data.'));
      }
    });
  }
  final WeatherRepository weatherRepository;
}
