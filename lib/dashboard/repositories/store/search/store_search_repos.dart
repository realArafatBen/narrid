import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/models/store/search/search_store_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoreSearchRepository {
  Future<List<SearchModal>> fetchSearch(String q) async {
    var url = Uri.parse('https://narrid.com/mobile/search/search.php');
    var response = await http.post(url, body: {
      'q': '$q',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList =
          data.map<SearchModal>((json) => SearchModal.fromJson(json)).toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<ProductsModel>> getCatalog(name) async {
    var url = Uri.parse('https://narrid.com/mobile/search/catalog.php');
    var response = await http.post(url, body: {
      'q': '$name',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(response.body);

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
