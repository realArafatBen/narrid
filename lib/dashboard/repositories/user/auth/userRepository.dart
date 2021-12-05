import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<Map<String, dynamic>> userRegister({
    String email,
    String password,
    String first_name,
    String last_name,
    String mobile,
    String state,
    String country,
  }) async {
    var url = Uri.parse('https://narrid.com/mobile/users/auth/register.php');
    var response = await http.post(url, body: {
      'first_name': '$first_name',
      'last_name': '$last_name',
      'email': '$email',
      'password': '$password',
      'mobile': '$mobile',
      'state': '$state',
      'country': '$country',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }

  Future<Map<String, dynamic>> userLogin(
      {String email, String password}) async {
    var url = Uri.parse('https://narrid.com/mobile/users/auth/login.php');
    var response = await http
        .post(url, body: {'email': '$email', 'password': '$password'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }

  Future<void> deleteToken() async {
    //delete from keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove boolean
    prefs.remove("userAuth");
    prefs.remove("first_name");
    prefs.remove("last_name");
    prefs.remove("userId");
    prefs.remove("email");
    return;
  }

  Future<void> persistToken(Map<String, dynamic> token) async {
    //write to keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userAuth', true);
    prefs.setString("first_name", token['first_name']);
    prefs.setString("last_name", token['last_name']);
    prefs.setString("userId", token['userId']);
    prefs.setString("email", token['email']);

    return;
  }

  Future<bool> hasToken() async {
    //read from keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkAuth = prefs.containsKey('userAuth');
    if (checkAuth == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String first_name = prefs.getString('first_name');
    String last_name = prefs.getString('last_name');
    String email = prefs.getString("email");
    String userId = prefs.getString("userId");
    Map<String, dynamic> token = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'userId': userId
    };
    return token;
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");
    return userId;
  }

  Future<String> getEmailAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("email");
    return userId;
  }

  Future<String> resetPassword(email) async {
    var url =
        Uri.parse('https://narrid.com/mobile/users/auth/reset-password.php');
    var response = await http.post(url, body: {'email': '$email'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return "Reset link has been sent to your email, check you reset your password";
      } else {
        return "Email not found on our server";
      }
    } else {
      String d = jsonDecode(response.reasonPhrase);
      return d;
    }
  }

  Future<Map<String, dynamic>> editAccount(
      first_name, last_name, mobile) async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var url =
        Uri.parse('https://narrid.com/mobile/users/account/edit-account.php');
    var response = await http.post(url, body: {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'mobile': mobile
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final d = jsonDecode(response.reasonPhrase);
      return d;
    }
  }

  Future<Map<String, dynamic>> fetchDetails() async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var url = Uri.parse('https://narrid.com/mobile/users/account/account.php');
    var response = await http.post(url, body: {
      'id': id,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final d = jsonDecode(response.reasonPhrase);
      return d;
    }
  }

  Future<Map<String, dynamic>> changePassword(password, prev_password) async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var url = Uri.parse(
        'https://narrid.com/mobile/users/account/change-password.php');
    var response = await http.post(url, body: {
      'id': id,
      'password': password,
      'prev_password': prev_password,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final data = jsonDecode(response.reasonPhrase);
      return data;
    }
  }

  Future<Map<String, dynamic>> getWalletBadge() async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var url = Uri.parse(
        'https://narrid.com/mobile/users/account/get_user_badge_wallet.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      Map<String, dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<Map<String, dynamic>> verifyWalletFunding(
      String ref, String amount) async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();

    var url = Uri.parse(
        'https://narrid.com/mobile/users/account/verify_wallet_funding.php');
    var response = await http.post(url, body: {
      'ref': ref,
      'userId': id,
      'amount': amount,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<dynamic>> getMemberLevel() async {
    var url = Uri.parse(
        'https://narrid.com/mobile/users/account/get_member_level_guide.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
