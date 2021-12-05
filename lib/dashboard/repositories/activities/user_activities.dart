import 'dart:convert';

import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:http/http.dart' as http;

class UserActivities {
  Future<void> productViewed(productId) async {
    UserRepository userRepository = UserRepository();
    bool token = await userRepository.hasToken();
    String login = "0";
    if (token) {
      login = "1";
    }

    var id = await userRepository.getUserId();

    var url =
        Uri.parse('https://narrid.com/mobile/activities/view-product.php');
    var response = await http.post(url, body: {
      'id': '$id',
      'productId': '$productId',
      'login': '$login',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);
    }
  }
}
