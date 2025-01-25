// screens/weather_screen.dart
// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:assessment/shared/constants/constants.dart';
import 'package:assessment/shared/utils/snackbar.dart';
import 'package:assessment/shared/utils/urls.dart';
import 'package:assessment/shared/utils/weather_util.dart';
import 'package:assessment/weather/presentation/state/blocs/weather_bloc.dart';
import 'package:assessment/weather/presentation/views/widgets/connectivity_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
    context.read<WeatherBloc>().add(const FetchWeather(kDefaultCity));
  }

  @override
  Widget build(BuildContext context) {
    // dimensions
    final size = MediaQuery.of(context).size;
    final width = size.width;
    // final height = size.height;

    return BlocListener<WeatherBloc, WeatherState>(
      bloc: context.watch<WeatherBloc>(),
      listener: (context, state) {
        if (state is WeatherError) {
          showSnackbar(
            context,
            state.message,
            color: Colors.red.shade600,
          );
        }
      },
      child: Scaffold(
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100.withOpacity(0.7),
                          ),
                          child: Image.asset(
                            'assets/images/png/cs_logo.png',
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const ConnectivityStatusWidget(),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Text(
                                'Weather Forecast',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade100.withOpacity(0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CupertinoSearchTextField(
                          controller: _cityController,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(80),
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            color: Colors.grey.shade100,
                          ),
                          suffixIcon: Icon(
                            CupertinoIcons.clear_thick_circled,
                            color: Colors.grey.shade100,
                          ),
                          placeholder: 'Enter the name of the city',
                          placeholderStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade100,
                            fontFamily: GoogleFonts.lato().fontFamily,
                            fontWeight: FontWeight.normal,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade100,
                            fontFamily: GoogleFonts.lato().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (value) {
                            final city = value.trim();
                            if (city.isNotEmpty) {
                              context
                                  .read<WeatherBloc>()
                                  .add(FetchWeather(city));
                            }
                          },
                          onChanged: (value) {
                            final city = value.trim();
                            if (city.isNotEmpty) {
                              context
                                  .read<WeatherBloc>()
                                  .add(FetchWeather(city));
                            }
                          },
                          onSuffixTap: () {
                            _cityController.clear();
                            context
                                .read<WeatherBloc>()
                                .add(const FetchWeather(kDefaultCity));
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
                        style: FilledButton.styleFrom(
                          foregroundColor: Colors.black87,
                          backgroundColor: Colors.grey.shade100,
                        ),
                        child: const Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Weather Data Display
                  BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      if (state is WeatherLoading) {
                        return Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.grey.shade100,
                          ),
                        );
                      } else if (state is WeatherLoaded) {
                        // Current Weather
                        final tomorrowForecast = state.forecastData['list']
                            .firstWhere((dynamic item) {
                          final now = DateTime.now();
                          final forecastDate =
                              DateTime.parse(item['dt_txt'] as String);
                          return forecastDate.day == now.day + 1;
                        });

                        // tomorrow conditions & icons
                        final tomorrowCondition = tomorrowForecast['weather']
                                    ?[0]?['description']
                                ?.toString() ??
                            '';
                        final tomorrowWeatherIcon =
                            getWeatherIcon(tomorrowCondition);

                        return Expanded(
                          child: RefreshIndicator.adaptive(
                            onRefresh: () async {
                              if (_cityController.text.isNotEmpty) {
                                context.read<WeatherBloc>().add(
                                      FetchWeather(_cityController.text.trim()),
                                    );
                              } else {
                                context
                                    .read<WeatherBloc>()
                                    .add(const FetchWeather(kDefaultCity));
                              }
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 3),
                                            child: Icon(
                                              Icons.calendar_month_sharp,
                                              color: Colors.grey.shade100,
                                              size: 11,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Last Updated: ${state.lastUpdated}',
                                              style: TextStyle(
                                                color: Colors.grey.shade100,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade100,
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          const Color.fromARGB(
                                            255,
                                            199,
                                            153,
                                            248,
                                          ).withOpacity(0.8),
                                          const Color(0xFF2575FC)
                                              .withOpacity(0.5),
                                          Colors.grey.shade100,
                                          const Color(0xFF2575FC)
                                              .withOpacity(0.5),
                                          const Color.fromARGB(
                                            255,
                                            199,
                                            153,
                                            248,
                                          ).withOpacity(0.8),
                                        ],
                                        stops: const [
                                          0.0,
                                          0.2,
                                          0.5,
                                          0.8,
                                          1.0,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(
                                            0,
                                            4,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              child: Icon(
                                                Icons.location_on,
                                              ),
                                            ),
                                            Text(
                                              "${state.weatherData['name'] as String? ?? ''}, ${state.weatherData['sys']['country'] as String? ?? ''}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${double.parse(state.weatherData['main']['temp'].toString()).toStringAsFixed(0)}°C',
                                          style: TextStyle(
                                            fontSize: 64,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                GoogleFonts.merriweather()
                                                    .fontFamily,
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
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 8,
                                        ),

                                        // Hourly Forecast
                                        Container(
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 8,
                                            itemBuilder: (context, index) {
                                              final forecast = state
                                                  .forecastData['list'][index];
                                              final hourlyCondition =
                                                  forecast['weather']?[0]
                                                              ?['description']
                                                          ?.toString() ??
                                                      '';
                                              final hourlyIcon = getWeatherIcon(
                                                hourlyCondition,
                                              );

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 8,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      '${double.parse(forecast['main']['temp'].toString()).toStringAsFixed(0)}°C',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Icon(
                                                      hourlyIcon.icon,
                                                      color: hourlyIcon.color,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      hourlyCondition,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 9,
                                                        color: Colors
                                                            .grey.shade700,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('HH:mm')
                                                          .format(
                                                        DateTime.parse(
                                                          forecast['dt_txt']
                                                              .toString(),
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: Colors
                                                            .grey.shade700,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            final date =
                                                DateFormat('d MMM').format(
                                              DateTime.parse(
                                                forecast['dt_txt'] as String,
                                              ),
                                            );
                                            final temp = double.parse(
                                              forecast['main']['temp']
                                                  .toString(),
                                            ).toStringAsFixed(0);

                                            final condition =
                                                forecast['weather']?[0]
                                                            ?['description']
                                                        ?.toString() ??
                                                    '';
                                            final weatherIcon =
                                                getWeatherIcon(condition);

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                        margin: const EdgeInsets
                                                            .only(
                                                          right: 8,
                                                        ),
                                                        child: Text(
                                                          '$dayName, $date',
                                                          style:
                                                              const TextStyle(
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
                                                            color: weatherIcon
                                                                .color,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            '$temp°C',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                                          color: Colors
                                                              .grey.shade700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.end,
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

                                  TextButton.icon(
                                    onPressed: () async {
                                      // launch my porfolio
                                      await UrlLauncherUtil.customLaunchUrl(
                                        kPortfolioURL,
                                        context: context,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.mobile_friendly,
                                      size: 18,
                                    ),
                                    label: Text(
                                      'Crafted by Erick Ogaro',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.grey.shade100,
                                        decorationThickness: 1.5,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey.shade100,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (state is WeatherError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(color: Colors.grey.shade100),
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          'Enter a city to get started.',
                          style: TextStyle(color: Colors.grey.shade100),
                        ),
                      );
                    },
                  ),
                ],
              ),
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
