import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/products/deliveryothers-details.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';

class DeliveryOthersRepos {
  Future<DeliveryOtherDetailsModel> getDetails(id) async {
    /** 
     * get the details from the server 
     */
    DeliveryOtherDetailsModel details = await getDetail(id);

    //return details list
    return details;
  }

  Future<DeliveryOtherDetailsModel> getDetail(id) async {
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var url = Uri.parse(
        'https://narrid.com/mobile/products/delivery-and-other-details.php');
    var response = await http.post(url, body: {
      'id': '$id',
      'city': '$city',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = DeliveryOtherDetailsModel.fromJson(data);
      return returnList;
    } else {
      DeliveryOtherDetailsModel error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
