import 'package:shared_preferences/shared_preferences.dart';

class LocationRespos {
  Future<bool> checkAuthLocation() async {
    //read from keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkAuth = prefs.containsKey('locationAuth');
    if (checkAuth == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double lat = prefs.getDouble('lat');
    double lng = prefs.getDouble('lng');
    String address = prefs.getString("address");
    String city = prefs.getString("city");
    Map<String, dynamic> token = {
      'lat': lat,
      'lng': lng,
      'address': address,
      'city': city,
    };
    return token;
  }

  Future<void> setAuthLocation(address, lat, lng, city) async {
    //write to keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('locationAuth', true);
    prefs.setDouble("lat", lat);
    prefs.setDouble("lng", lng);
    prefs.setString("city", city);
    prefs.setString("address", address);
    return;
  }

  Future<String> getLocationForProduct() async {
    bool loc = await this.checkAuthLocation();
    var city = "";
    if (loc) {
      Map<String, dynamic> myloc = await this.fetchLocation();
      city = myloc['city'];
    } else {
      city = "";
    }

    return city;
  }
}
