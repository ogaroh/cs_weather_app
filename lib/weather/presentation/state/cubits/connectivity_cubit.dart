import 'package:assessment/weather/presentation/state/cubits/connectivity_state.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit(this._connectivity) : super(ConnectivityInitial()) {
    _monitorConnectivity();
  }
  final Connectivity _connectivity;

  void _monitorConnectivity() {
    _connectivity.onConnectivityChanged.listen((status) {
      if (status.isEmpty) {
        emit(ConnectivityOffline());
      } else {
        emit(ConnectivityOnline());
      }
    });
  }
}
