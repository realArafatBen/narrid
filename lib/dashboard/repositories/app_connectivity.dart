import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppConnectivity with ChangeNotifier {
  Connectivity _connectivity = new Connectivity();
  bool _isOnline = false;
  bool get isOnline => _isOnline;

  startMonitoring() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged.listen((event) async {
      if (event == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      } else {
        await _updateConectivity().then((bool isConnected) {
          _isOnline = isConnected;
          notifyListeners();
        });
      }
    });
  }

  Future<void> initConnectivity() async {
    try {
      var status = await _connectivity.checkConnectivity();
      if (status == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      } else {
        _isOnline = await _updateConectivity();
        notifyListeners();
      }
    } on PlatformException catch (_) {
      _isOnline = false;
      notifyListeners();
    }
  }

  Future<bool> _updateConectivity() async {
    bool isConnected = false;

    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup("example.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      } else {
        isConnected = false;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }
}
