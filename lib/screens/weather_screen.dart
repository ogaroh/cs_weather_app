// screens/weather_screen.dart
// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:assessment/blocs/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            'assets/images/png/cs_logo.png',
            height: 45,
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: 'Enter City',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      final city = _cityController.text.trim();
                      if (city.isNotEmpty) {
                        context.read<WeatherBloc>().add(FetchWeather(city));
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Weather Data Display
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
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

                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              state.weatherData['name'] as String,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${double.parse(state.weatherData['main']['temp'].toString()).toStringAsFixed(0)}°C',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              state.weatherData['weather'][0]['description']
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Hourly Forecast
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  final forecast =
                                      state.forecastData['list'][index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${double.parse(forecast['main']['temp'].toString()).toStringAsFixed(0)}°C',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SvgPicture.asset(
                                          'assets/images/svg/cloudy.svg',
                                          colorFilter: ColorFilter.mode(
                                            Colors.blue.shade900,
                                            BlendMode.srcIn,
                                          ),
                                          height: 40,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          forecast['dt_txt']
                                              .split(' ')[1]
                                              .toString(),
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Tomorrow's Forecast
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    "Tomorrow's Forecast",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        'assets/images/svg/cloudy.svg',
                                        colorFilter: ColorFilter.mode(
                                          Colors.blue.shade900,
                                          BlendMode.srcIn,
                                        ),
                                        height: 40,
                                      ),
                                      Text(
                                        tomorrowForecast['weather'][0]
                                                ['description']
                                            .toString(),
                                        style: const TextStyle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is WeatherError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
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
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
