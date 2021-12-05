import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';

class CustomerViewRepos {
  Future<List<ProductsModel>> getProducts(id) async {
    /** 
     * get the products from the server 
     */
    List<ProductsModel> products = await getProduct(id);

    //return product list
    return products;
  }

  Future<List<ProductsModel>> getProduct(id) async {
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var url = Uri.parse('https://narrid.com/mobile/products/customerview.php');
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
