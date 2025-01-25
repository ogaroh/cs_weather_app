import 'package:assessment/shared/utils/snackbar.dart';
import 'package:assessment/weather/presentation/state/cubits/connectivity_cubit.dart';
import 'package:assessment/weather/presentation/state/cubits/connectivity_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityStatusWidget extends StatelessWidget {
  const ConnectivityStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, ConnectivityState>(
      bloc: context.watch<ConnectivityCubit>(),
      listener: (context, state) {
        if (state is ConnectivityOffline) {
          showSnackbar(
            context,
            "You're offline. Please connect to the internet and try again.",
            color: Colors.red.shade700,
            icon: Icons.cancel,
          );
        } else if (state is ConnectivityOnline) {
          showSnackbar(
            context,
            "You're back online. Refresh the page to get latest data.",
            color: Colors.green.shade700,
            icon: Icons.check_circle,
          );
        }
      },
      child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          Color? color;
          var status = 'Unknown';

          if (state is ConnectivityOnline) {
            color = Colors.green.shade700;
            status = 'Online';
          } else if (state is ConnectivityOffline) {
            color = Colors.red.shade700;
            status = 'Offline';
          } else {
            color = Colors.grey.shade700;
            status = 'Unknown';
          }

          return Badge(
            label: Text(
              status,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: color,
            textColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          );
        },
      ),
    );
  }
}
