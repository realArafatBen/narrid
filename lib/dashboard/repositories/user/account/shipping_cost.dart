import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/utils/helpers/database_helper.dart';

class ShippingCostResp {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  Future<Map<String, dynamic>> fetchShippingCost() async {
    //get the user Id
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    //get the product in cart
    CartRepository cartRepository = CartRepository();
    List<Map<String, dynamic>> cart = await cartRepository.getProductShipping();

    var body = json.encode({"productId": cart, "userId": id});
    var url = Uri.parse('https://narrid.com/mobile/checkout/shipping_cost.php');
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
}
