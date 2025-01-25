import 'dart:developer';
import 'dart:io';

import 'package:assessment/weather/presentation/state/cubits/connectivity_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit(this._connectivity) : super(ConnectivityInitial()) {
    _monitorConnectivity();
  }
  final Connectivity _connectivity;

  void _monitorConnectivity() {
    _connectivity.onConnectivityChanged.listen((status) async {
      log(status.toString(), name: '_monitorConnectivity');
      if (status.isEmpty || status.contains(ConnectivityResult.none)) {
        emit(ConnectivityOffline());
      } else {
        // Ping a site to verify actual internet access
        final canReachInternet = await _pingSite();
        if (canReachInternet) {
        emit(ConnectivityOnline());
        } else {
          emit(ConnectivityOffline());
        }
      }
    });
  }

  // Helper method to ping a site
  Future<bool> _pingSite() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true; // Internet is accessible
      }
    } catch (_) {
      // Ping failed
    }
    return false; // No internet access
  }
}
