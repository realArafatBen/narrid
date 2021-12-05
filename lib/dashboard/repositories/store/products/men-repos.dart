import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';

class MenRepos {
  Future<List<ProductsModel>> getProducts() async {
    /** 
     * get the products from the server 
     */
    List<ProductsModel> products = await getProduct();

    //return product list
    return products;
  }

  Future<List<ProductsModel>> getProduct() async {
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var url = Uri.parse('https://narrid.com/mobile/products/men.php');
    var response = await http.post(url, body: {
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
}
