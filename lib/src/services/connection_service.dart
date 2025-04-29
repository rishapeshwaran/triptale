import 'package:connectivity_plus/connectivity_plus.dart';

void checkInternet() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile) {
    print("Connected to Mobile Network");
  } else if (connectivityResult == ConnectivityResult.wifi) {
    print("Connected to WiFi");
  } else {
    print("No Internet Connection");
  }
}
