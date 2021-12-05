import 'package:http/http.dart' as http;
import 'dart:convert';

class BrandsRepository {
  Future<List<dynamic>> getBrands(id) async {
    var url = Uri.parse("https://narrid.com/mobile/brands/get_brands.php");
    var response = await http.post(url, body: {
      'id': '$id',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }
}
