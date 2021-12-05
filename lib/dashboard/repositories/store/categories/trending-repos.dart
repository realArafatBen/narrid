import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';

class TrendingRepos {
  Future<List<ProductsModel>> getProducts(categoryId, brandId, productType,
      shipping_type, min_price, max_price) async {
    /** 
     * get the products from the server 
     */
    List<ProductsModel> products = await getProduct(
        categoryId, brandId, productType, shipping_type, min_price, max_price);

    //return product list
    return products;
  }

  Future<List<ProductsModel>> getProduct(categoryId, brandId, productType,
      shipping_type, min_price, max_price) async {
    var url = Uri.parse('https://narrid.com/mobile/products/trending.php');

    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var response = await http.post(url, body: {
      'categoryId': '$categoryId',
      'brandId': '$brandId',
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
      // List<BannersModel> returnList = BannersModel.fromJson(data).image;
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<dynamic>> getTrendCategory() async {
    var url =
        Uri.parse('https://narrid.com/mobile/categories/top_categories.php');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
