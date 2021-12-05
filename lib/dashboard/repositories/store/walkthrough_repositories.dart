import 'package:shared_preferences/shared_preferences.dart';

class WalkThroughRepositories {
  // check if walkthrough is set
  Future<bool> hasWalkThrough() async {
    //read from keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkAuth = prefs.containsKey('walk_through');
    if (checkAuth == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> setWalkThrough() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('walk_through', true);
    return;
  }
}
