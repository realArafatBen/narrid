import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/repositories/store/checkout_cart_repository.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class PaystackRespo {
  Future<Map<String, dynamic>> initialize(
    String shipping,
    String total,
  ) async {
    //get the user Id
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var email = await userRepository.getEmailAddress();
    //get the product in cart
    CheckoutCartRepository cartRepository = CheckoutCartRepository();
    List<Map<String, dynamic>> cart = await cartRepository.getProductShipping();

    var body = json.encode({
      "products": cart,
      "userId": id,
      "total": total,
      "email": email,
      "shipping": shipping
    });
    var url = Uri.parse('https://narrid.com/mobile/checkout/initialize.php');
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

  Future<Map<String, dynamic>> walletTopUp(amount) async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var email = await userRepository.getEmailAddress();
    var url =
        Uri.parse('https://narrid.com/mobile/users/account/top_up_wallet.php');
    var response = await http.post(url, body: {
      'id': '$id',
      'amount': '$amount',
      'email': '$email',
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
