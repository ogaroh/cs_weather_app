// ignore_for_file: inference_failure_on_function_invocation

import 'dart:io';

import 'package:assessment/shared/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class WeatherRepository {
  final Dio _dio = Dio();
  final String _apiKey = kApiKey;
  final String _baseUrl = kBaseUrl;
  final _weatherBox = Hive.box(weatherBox);

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

  // Fetch current weather with offline support
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

      // Save to Hive
      await _weatherBox.put('currentWeather', response.data);
      await _weatherBox.put(
        'lastUpdated',
        DateFormat('EEE dd/MM/yyyy, HH:mm:ss').format(DateTime.now()),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (error) {
      // On DioException, check for cached data
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.error is SocketException) {
        final cachedWeather = _weatherBox.get('currentWeather');
        if (cachedWeather != null) {
          return cachedWeather as Map<String, dynamic>;
        }
        throw Exception('No internet and no cached data available.');
      }
      throw _handleDioException(error);
    } catch (error) {
      throw Exception('An unexpected error occurred: $error');
    }
  }

  // Fetch weather forecast with offline support
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

      // Save to Hive
      await _weatherBox.put('weatherForecast', response.data);
      await _weatherBox.put(
        'lastUpdated',
        DateFormat('EEE dd/MM/yyyy, HH:mm:ss').format(DateTime.now()),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (error) {
      // On DioException, check for cached data
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.error is SocketException) {
        final cachedForecast = _weatherBox.get('weatherForecast');
        if (cachedForecast != null) {
          return cachedForecast as Map<String, dynamic>;
        }
        throw Exception('No internet and no cached data available.');
      }
      throw _handleDioException(error);
    } catch (error) {
      throw Exception('An unexpected error occurred: $error');
    }
  }

  // Get last updated timestamp
  String getLastUpdated() {
    return _weatherBox.get('lastUpdated', defaultValue: 'Never') as String;
  }
}
