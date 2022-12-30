import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final internetCheckerProvider = Provider<InternetConnectionChecker>((ref) {
 return InternetConnectionChecker();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
 final internetCheckerRef = ref.read(internetCheckerProvider);
  return NetworkInfo(internetCheckerRef);
});

class NetworkInfo{
 final InternetConnectionChecker _internetConnectionChecker;
 NetworkInfo(this._internetConnectionChecker);

 Future<bool> get isConnected async=> await _internetConnectionChecker.hasConnection;
}