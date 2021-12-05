import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class AddressRepos {
  Future<Map<String, dynamic>> fetchUserDefaultAddress() async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var url =
        Uri.parse('https://narrid.com/mobile/users/account/get-address.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }
}
