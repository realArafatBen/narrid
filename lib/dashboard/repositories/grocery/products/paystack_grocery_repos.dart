import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/repositories/grocery/products/products_repos.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class PaystackGroceryRespo {
  Future<Map<String, dynamic>> initialize(
    String shipping,
    String total,
  ) async {
    //get the user Id
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var email = await userRepository.getEmailAddress();
    //get coord
    LocationRespos locationRespos = LocationRespos();
    var location = await locationRespos.fetchLocation();

    //get the product in cart
    GroceryProductRep cartRepository = GroceryProductRep();
    List<Map<String, dynamic>> cart = await cartRepository.getProductShipping();

    var body = json.encode({
      "products": cart,
      "userId": id,
      "total": total,
      "email": email,
      "shipping": shipping,
      "address": location['address'],
      "lat": location['lat'].toString(),
      "lng": location['lng'].toString(),
    });
    var url = Uri.parse('https://narrid.com/mobile/grocery/initialize.php');
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
    var url = Uri.parse('https://narrid.com/mobile/grocery/verify.php');
    var response = await http.post(url, body: {
      'ref': ref,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      //clear the cart
      GroceryProductRep cartRepository = GroceryProductRep();
      await cartRepository.clearCart();
      //
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
