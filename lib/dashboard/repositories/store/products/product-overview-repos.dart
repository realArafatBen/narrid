import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/products/product-overview.dart';

class ProductOverviewRepos {
  Future<ProductOverviewModel> getOverviews(id) async {
    /** 
     * get the overview from the server 
     */
    ProductOverviewModel overview = await getOverview(id);

    //return overview
    return overview;
  }

  Future<ProductOverviewModel> getOverview(id) async {
    var url =
        Uri.parse('https://narrid.com/mobile/products/product-overview.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = ProductOverviewModel.fromJson(data);
      return returnList;
    } else {
      ProductOverviewModel error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
