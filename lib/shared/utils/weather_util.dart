import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherIcon {
  WeatherIcon(this.icon, this.color);
  final IconData icon;
  final Color color;
}

WeatherIcon getWeatherIcon(String condition) {
  switch (condition.toLowerCase()) {
    case 'clear sky':
      return WeatherIcon(
        WeatherIcons.day_sunny,
        Colors.orange,
      );
    case 'few clouds':
      return WeatherIcon(
        WeatherIcons.cloudy,
        Colors.grey,
      );
    case 'scattered clouds':
      return WeatherIcon(
        WeatherIcons.cloudy_gusts,
        Colors.blueGrey.shade600,
      );
    case 'broken clouds':
      return WeatherIcon(
        WeatherIcons.cloud,
        Colors.grey.shade700,
      );
    case 'overcast clouds':
      return WeatherIcon(
        WeatherIcons.cloudy,
        Colors.grey.shade600,
      );
    case 'shower rain':
      return WeatherIcon(
        WeatherIcons.rain_wind,
        Colors.blue.shade800,
      );
    case 'light rain':
      return WeatherIcon(
        WeatherIcons.rain_mix,
        Colors.blue.shade800,
      );
    case 'moderate rain':
      return WeatherIcon(
        WeatherIcons.rain_mix,
        Colors.blue.shade600,
      );
    case 'rain':
      return WeatherIcon(
        WeatherIcons.rain,
        Colors.blue.shade800,
      );
    case 'thunderstorm':
      return WeatherIcon(
        WeatherIcons.thunderstorm,
        Colors.pink,
      );
    case 'snow':
      return WeatherIcon(
        WeatherIcons.snow,
        Colors.lightBlue,
      );
    case 'light snow':
      return WeatherIcon(
        WeatherIcons.snowflake_cold,
        Colors.lightBlue,
      );
    case 'mist':
      return WeatherIcon(
        WeatherIcons.fog,
        Colors.grey.shade400,
      );
    default:
      return WeatherIcon(
        WeatherIcons.alien,
        Colors.teal.shade400,
      );
  }
}
