import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/categories/categories.dart';

class SubCategoriesRepos {
  Future<List<CategoriesModel>> getCategories(catId) async {
    /** 
     * get the categories from the server 
     */
    List<CategoriesModel> categories = await getCategory(catId);

    //return categories list
    return categories;
  }

  Future<List<CategoriesModel>> getCategory(catId) async {
    var url =
        Uri.parse('https://narrid.com/mobile/categories/sub_categories.php');
    var response = await http.post(url, body: {
      'id': '$catId',
    });

    if (response.statusCode == 200) {
      // print(response.body);
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
