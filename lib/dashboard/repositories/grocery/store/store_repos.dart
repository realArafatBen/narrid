import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/grocery/store_model.dart';

class StoreRepos {
  Future<List<StoreModel>> getStores() async {
    var url = Uri.parse('https://narrid.com/mobile/grocery/stores.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList =
          data.map<StoreModel>((json) => StoreModel.fromJson(json)).toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
