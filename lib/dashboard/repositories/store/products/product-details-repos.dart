import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/products/product-details.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';

class ProductDetailsRepos {
  Future<ProductDetailsModel> getDetails(id) async {
    /** 
     * get the product from the server 
     */
    ProductDetailsModel details = await getDetail(id);

    //return product list
    return details;
  }

  Future<ProductDetailsModel> getDetail(id) async {
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var url =
        Uri.parse('https://narrid.com/mobile/products/product-details.php');
    var response = await http.post(url, body: {
      'id': '$id',
      'city': '$city',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = ProductDetailsModel.fromJson(data);
      return returnList;
    } else {
      ProductDetailsModel error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
