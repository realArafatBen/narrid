import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductImageRep {
  Future<List<dynamic>> getImages(id) async {
    /**
     * get the categories from the server
     */
    List<dynamic> images = await getImage(id);

    //return banner list
    return images;
  }

  Future<List<dynamic>> getImage(id) async {
    var url =
        Uri.parse('https://narrid.com/mobile/products/product-images.php');
    var response = await http.post(url, body: {
      'id': '$id',
    });
    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      final returnList = data.toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
