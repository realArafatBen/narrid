import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/categories/categories.dart';

class CategoriesRepos {
  Future<List<CategoriesModel>> getCategories() async {
    /** 
     * get the categories from the server 
     */
    List<CategoriesModel> categories = await getCategory();

    //return categories list
    return categories;
  }

  Future<List<CategoriesModel>> getCategory() async {
    var url = Uri.parse('https://narrid.com/mobile/categories/categories.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<CategoriesModel>((json) => CategoriesModel.fromJson(json))
          .toList();
      // List<BannersModel> returnList = BannersModel.fromJson(data).image;
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
