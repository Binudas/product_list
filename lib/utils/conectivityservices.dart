import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final Logger _logger = Logger();

  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _logger.d('Current connectivity result: $connectivityResult');
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
  }

  Future<ConnectivityResult> checkConnectivityResult() async {
    return await _connectivity.checkConnectivity().then(
      (results) => results.first,
    );
  }
}
