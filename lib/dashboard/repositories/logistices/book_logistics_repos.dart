import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class BookRepository {
  Future<Map<String, dynamic>> bookCash(
    Map<String, dynamic> map,
  ) async {
    //get the user Id
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    //add the userId
    map['userId'] = id;
    var body = json.encode(map);

    var url = Uri.parse('https://narrid.com/mobile/logistics/cash.php');
    var response = await http
        .post(url, body: body, headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<Map<String, dynamic>> bookCard(
    Map<String, dynamic> map,
  ) async {
    //get the user Id
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var email = await userRepository.getEmailAddress();
    //add the userId
    map['userId'] = id;
    map['email'] = email;
    var body = json.encode(map);

    var url = Uri.parse('https://narrid.com/mobile/logistics/initialize.php');
    var response = await http
        .post(url, body: body, headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<Map<String, dynamic>> verify(String ref) async {
    var url = Uri.parse('https://narrid.com/mobile/logistics/verify.php');
    var response = await http.post(url, body: {
      'ref': ref,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
