import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/models/food/store_model.dart';
import 'dart:convert';

class StoreRepos {
  Future<List<StoreFoodModel>> getStores() async {
    var url = Uri.parse('https://narrid.com/mobile/food/stores.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<StoreFoodModel>((json) => StoreFoodModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
