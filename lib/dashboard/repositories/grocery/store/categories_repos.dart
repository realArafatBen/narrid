import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/categories/categories.dart';

class CategoryRepos {
  Future<List<CategoriesModel>> getCategories() async {
    var url = Uri.parse('https://narrid.com/mobile/grocery/categories.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<CategoriesModel>((json) => CategoriesModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
