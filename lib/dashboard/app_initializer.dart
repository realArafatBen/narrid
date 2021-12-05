import 'package:narrid/dashboard/repositories/app_connectivity.dart';

///
/// App Initailizer
/// this check for internet connectivity and get the app theme stored
/// on the user device
///

class AppInitializer {
  ///
  /// initialize the app
  /// check connectivity
  /// get theme
  ///
  Future<Map<String, dynamic>> appInitializer() async {
    /**
     * get Notification status
     */
    AppConnectivity appConnectivity = new AppConnectivity();
    await appConnectivity.initConnectivity();
    bool connectivityStatus = appConnectivity.isOnline;

    //set delay
    await Future.delayed(Duration(seconds: 5));

    var data = {
      "connectivity_status": connectivityStatus,
    };
    return data;
  }
}
