import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/models/store/account/addresses_modal.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class AddressesRepos {
  Future<List<AddressModal>> fetchUserDefaultAddress() async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var url =
        Uri.parse('https://narrid.com/mobile/users/account/addresses.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<AddressModal>((json) => AddressModal.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<Map<String, dynamic>> makeDefault(id) async {
    var url = Uri.parse(
        'https://narrid.com/mobile/users/account/make-default-address.php');
    var response = await http.post(url, body: {'id': '$id'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }

  Future<List<AddressModal>> fetchLocalState() async {
    var url = Uri.parse('https://locationsng-api.herokuapp.com/api/v1/lgas');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<AddressModal>((json) => AddressModal.fromJsonCity(json))
          .toList();
      return returnList;
    } else {
      final error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }

  Future<List<dynamic>> fetchLocalLGA(city) async {
    var url = Uri.parse(
        'https://locationsng-api.herokuapp.com/api/v1/states/$city/lgas');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }

  Future<Map<String, dynamic>> addUserAddress(
      first_name, last_name, line1, line2, address, city, region) async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var url =
        Uri.parse('https://narrid.com/mobile/users/account/add-address.php');
    var response = await http.post(url, body: {
      'id': '$id',
      'first_name': first_name,
      'last_name': last_name,
      'line1': line1,
      'line2': line2,
      'address': address,
      'city': city,
      'region': region
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      Map<String, dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
