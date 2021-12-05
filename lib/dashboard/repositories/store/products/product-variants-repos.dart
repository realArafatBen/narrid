import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/products/product-variants.dart';

class ProductVariantsRepos {
  Future<List<ProductVariantsModel>> getVariants(id) async {
    /** 
     * get the variants from the server 
     */
    List<ProductVariantsModel> variants = await getVariant(id);

    //return variants list
    return variants;
  }

  Future<List<ProductVariantsModel>> getVariant(id) async {
    var url =
        Uri.parse('https://narrid.com/mobile/products/product-variants.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<ProductVariantsModel>(
              (json) => ProductVariantsModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<Map<String, dynamic>> getColors(id) async {
    var url = Uri.parse('https://narrid.com/mobile/products/product-color.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      Map<String, dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
