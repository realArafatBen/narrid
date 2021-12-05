import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';

class ProductCategoriesRepos {
  Future<List<ProductsModel>> getProducts(
    id,
    brandId,
    max_price,
    min_price,
    productType,
    shipping_type,
  ) async {
    /** 
     * get the products from the server 
     */
    List<ProductsModel> products = await getProduct(
      id,
      brandId,
      max_price,
      min_price,
      productType,
      shipping_type,
    );

    //return product list
    return products;
  }

  Future<List<ProductsModel>> getProduct(
    id,
    brandId,
    max_price,
    min_price,
    productType,
    shipping_type,
  ) async {
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var url = Uri.parse('https://narrid.com/mobile/products/categories.php');
    var response = await http.post(url, body: {
      'id': '$id',
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
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<ProductsModel>> getVendorProducts(id) async {
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var url =
        Uri.parse('https://narrid.com/mobile/products/vendor-products.php');
    var response = await http.post(url, body: {
      'id': '$id',
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
}
