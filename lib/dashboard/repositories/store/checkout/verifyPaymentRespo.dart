import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/repositories/store/checkout_cart_repository.dart';

class VerifyPaymentRespo {
  Future<Map<String, dynamic>> verify(String ref) async {
    var url = Uri.parse('https://narrid.com/mobile/checkout/verify.php');
    var response = await http.post(url, body: {
      'ref': ref,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      //clear the cart
      CheckoutCartRepository cartRepository = CheckoutCartRepository();
      await cartRepository.clearCartAfterPurchase();
      //
      return data;
    } else {
      final error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
