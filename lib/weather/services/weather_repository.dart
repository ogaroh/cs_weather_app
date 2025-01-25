// services/weather_repository.dart
// ignore_for_file: inference_failure_on_function_invocation

import 'dart:io';

import 'package:assessment/shared/constants/constants.dart';
import 'package:dio/dio.dart';

class WeatherRepository {
  final Dio _dio = Dio();
  final String _apiKey = kApiKey;
  final String _baseUrl = kBaseUrl;

  // Custom exception handler
  Exception _handleDioException(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const SocketException('Connection timed out. Please try again.');
    } else if (error.type == DioExceptionType.badResponse) {
      if (error.response?.statusCode == 404) {
        return Exception('City not found. Please check the city name.');
      } else if (error.response?.statusCode == 401) {
        return Exception('Invalid API key. Please contact support.');
      } else {
        return Exception('An error occurred: ${error.response?.statusMessage}');
      }
    } else if (error.type == DioExceptionType.cancel) {
      return Exception('Request was canceled. Please try again.');
    } else {
      return Exception('An unexpected error occurred. Please try again.');
    }
  }

  // Fetch current weather
  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'q': city,
          'appid': _apiKey,
          'units': 'metric',
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (error) {
      throw _handleDioException(error);
    } catch (error) {
      throw Exception('An unexpected error occurred: $error');
    }
  }

  // Fetch weather forecast
  Future<Map<String, dynamic>> fetchWeatherForecast(String city) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/forecast',
        queryParameters: {
          'q': city,
          'appid': _apiKey,
          'units': 'metric',
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (error) {
      throw _handleDioException(error);
    } catch (error) {
      throw Exception('An unexpected error occurred: $error');
    }
  }
}
