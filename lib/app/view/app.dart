// ignore_for_file: lines_longer_than_80_chars

import 'package:assessment/counter/cubit/counter_cubit.dart';
import 'package:assessment/l10n/l10n.dart';
import 'package:assessment/shared/theme/theme.dart';
import 'package:assessment/shared/theme/util.dart';
import 'package:assessment/weather/presentation/state/blocs/weather_bloc.dart';
import 'package:assessment/weather/presentation/state/cubits/connectivity_cubit.dart';
import 'package:assessment/weather/presentation/views/screens/weather_screen.dart';
import 'package:assessment/weather/services/weather_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;

    final textTheme = createTextTheme(context, 'Lato', 'Lato');

    final theme = MaterialTheme(textTheme);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(WeatherRepository()),
        ),
        BlocProvider(
          create: (context) => CounterCubit(),
        ),
        BlocProvider(
          create: (context) => ConnectivityCubit(Connectivity()),
        ),
      ],
      child: MaterialApp(
        // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        theme: theme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const WeatherScreen(),
      ),
    );
  }
}
