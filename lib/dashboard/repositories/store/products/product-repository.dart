import 'dart:convert';

import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class ProductRepository {
  Future<List<ProductsModel>> getProductsBrand(
    id,
    categoryId,
    max_price,
    min_price,
    productType,
    shipping_type,
  ) async {
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var url = Uri.parse('https://narrid.com/mobile/products/product-brand.php');
    var response = await http.post(url, body: {
      'id': '$id',
      'categoryId': '$categoryId',
      'min_price': '$min_price',
      'max_price': '$max_price',
      'productType': '$productType',
      'shipping_type': '$shipping_type',
      'city': '$city',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final returnList = data
          .map<ProductsModel>((json) => ProductsModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }

  Future<List<ProductsModel>> getViewedProduct() async {
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    UserRepository userRepository = UserRepository();
    var id = await userRepository.getUserId();
    var url =
        Uri.parse('https://narrid.com/mobile/products/getViewedProducts.php');
    var response = await http.post(url, body: {
      'id': '$id',
      city: '$city',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final returnList = data
          .map<ProductsModel>((json) => ProductsModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }
}
