// services/weather_repository.dart
// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherRepository {
  final Dio _dio = Dio();
  final String _apiKey = dotenv.env['API_KEY'] ?? '';
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';


  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final response = await _dio.get(
      '$_baseUrl/weather',
      queryParameters: {
        'q': city,
        'appid': _apiKey,
        'units': 'metric',
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchWeatherForecast(String city) async {
    final response = await _dio.get(
      '$_baseUrl/forecast',
      queryParameters: {
        'q': city,
        'appid': _apiKey,
        'units': 'metric',
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
