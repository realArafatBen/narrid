import 'package:narrid/dashboard/models/store/order/order_modal.dart';
import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/models/store/order/order_product_modal.dart';
import 'dart:convert';

import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class GroceryOrdersRepository {
  Future<List<OrderModel>> fetchOrders() async {
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var url = Uri.parse('https://narrid.com/mobile/grocery/order/orders.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final returnList =
          data.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
      return returnList;
    } else {
      List<OrderModel> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<String> fetchImage(id) async {
    var url =
        Uri.parse('https://narrid.com/mobile/grocery/order/orders-image.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });

    if (response.statusCode == 200) {
      final data = response.body;

      return data.toString();
    } else {
      String error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<OrderProductModel>> fetchOrderProduct(id) async {
    var url = Uri.parse('https://narrid.com/mobile/grocery/order/order.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final returnList = data
          .map<OrderProductModel>((json) => OrderProductModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<OrderProductModel> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<String> fetchProductImage(id) async {
    var url =
        Uri.parse('https://narrid.com/mobile/grocery/order/product-image.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });

    if (response.statusCode == 200) {
      final data = response.body;

      return data.toString();
    } else {
      String error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
