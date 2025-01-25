// screens/weather_screen.dart
// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:assessment/shared/utils/weather_util.dart';
import 'package:assessment/weather/presentation/blocs/weather_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

const defaultCity = 'Nairobi';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(const FetchWeather(defaultCity));
  }

  @override
  Widget build(BuildContext context) {
    // dimensions
    final size = MediaQuery.of(context).size;
    final width = size.width;
    // final height = size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/jpg/sky.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.asset(
                    'assets/images/png/cs_logo.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CupertinoSearchTextField(
                        controller: _cityController,
                        placeholder: 'Enter the name of the city',
                        onSubmitted: (value) {
                          final city = value.trim();
                          if (city.isNotEmpty) {
                            context.read<WeatherBloc>().add(FetchWeather(city));
                          }
                        },
                        onChanged: (value) {
                          final city = value.trim();
                          if (city.isNotEmpty) {
                            context.read<WeatherBloc>().add(FetchWeather(city));
                          }
                        },
                        onSuffixTap: () {
                          _cityController.clear();
                          context
                              .read<WeatherBloc>()
                              .add(const FetchWeather(defaultCity));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: () {
                        final city = _cityController.text.trim();
                        if (city.isNotEmpty) {
                          context.read<WeatherBloc>().add(FetchWeather(city));
                        }
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
                // Weather Data Display
                BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherLoading) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    } else if (state is WeatherLoaded) {
                      // Current Weather
                      final tomorrowForecast =
                          state.forecastData['list'].firstWhere((dynamic item) {
                        final now = DateTime.now();
                        final forecastDate =
                            DateTime.parse(item['dt_txt'] as String);
                        return forecastDate.day == now.day + 1;
                      });

                      // tomorrow conditions & icons
                      final tomorrowCondition = tomorrowForecast['weather']?[0]
                                  ?['description']
                              ?.toString() ??
                          '';
                      final tomorrowWeatherIcon =
                          getWeatherIcon(tomorrowCondition);

                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade100,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "${state.weatherData['name'] as String? ?? ''}, ${state.weatherData['sys']['country'] as String? ?? ''}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${double.parse(state.weatherData['main']['temp'].toString()).toStringAsFixed(0)}°C',
                                      style: const TextStyle(
                                        fontSize: 64,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Feels like ${double.parse(state.weatherData['main']['feels_like'].toString()).toStringAsFixed(0)}°C',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      state.weatherData['weather']?[0]
                                              ?['description'] as String? ??
                                          '',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Hourly Forecast
                                    Container(
                                      height: 120,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 8,
                                        itemBuilder: (context, index) {
                                          final forecast =
                                              state.forecastData['list'][index];
                                          final hourlyCondition =
                                              forecast['weather']?[0]
                                                          ?['description']
                                                      ?.toString() ??
                                                  '';
                                          final hourlyIcon =
                                              getWeatherIcon(hourlyCondition);

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '${double.parse(forecast['main']['temp'].toString()).toStringAsFixed(0)}°C',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Icon(
                                                  hourlyIcon.icon,
                                                  color: hourlyIcon.color,
                                                  size: 30,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  hourlyCondition,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 9,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('HH:mm').format(
                                                    DateTime.parse(
                                                      forecast['dt_txt']
                                                          .toString(),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Tomorrow's Forecast
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade100,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tomorrow',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${double.parse(tomorrowForecast['main']['temp_min'].toString()).toStringAsFixed(0)}°C / ${double.parse(tomorrowForecast['main']['temp_max'].toString()).toStringAsFixed(0)}°C',
                                          style: const TextStyle(
                                            // fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          tomorrowWeatherIcon.icon,
                                          color: tomorrowWeatherIcon.color,
                                          size: 20,
                                        ),
                                        Text(
                                          tomorrowCondition,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade800,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // 5-Day Forecast
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '5-Day Forecast',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        final forecast = state
                                            .forecastData['list']
                                            .where((dynamic item) {
                                          // Filter to get one forecast per day at midday (12:00)
                                          final time = DateTime.parse(
                                            item['dt_txt'] as String,
                                          );
                                          return time.hour == 12;
                                        }).toList()[index];

                                        final dayName =
                                            DateFormat('EEE').format(
                                          DateTime.parse(
                                            forecast['dt_txt'] as String,
                                          ),
                                        );
                                        final date = DateFormat('d MMM').format(
                                          DateTime.parse(
                                            forecast['dt_txt'] as String,
                                          ),
                                        );
                                        final temp = double.parse(
                                          forecast['main']['temp'].toString(),
                                        ).toStringAsFixed(0);

                                        final condition = forecast['weather']
                                                    ?[0]?['description']
                                                ?.toString() ??
                                            '';
                                        final weatherIcon =
                                            getWeatherIcon(condition);

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: width / 2.5,
                                                    margin:
                                                        const EdgeInsets.only(
                                                      right: 8,
                                                    ),
                                                    child: Text(
                                                      '$dayName, $date',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        weatherIcon.icon,
                                                        color:
                                                            weatherIcon.color,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        '$temp°C',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    condition,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 11,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ],
                                              ),
                                              const Divider(thickness: 0.5),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is WeatherError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(),
                        ),
                      );
                    }
                    return const Center(
                      child: Text(
                        'Enter a city to get started.',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
