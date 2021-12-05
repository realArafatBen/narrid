import 'dart:convert';

import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:http/http.dart' as http;

class ExtimateDeliveryRepos {
  Future<Map<String, dynamic>> getExtimateTime(origin_lat, origin_lng) async {
    LocationRespos locationRespos = LocationRespos();
    Map<String, dynamic> location = await locationRespos.fetchLocation();
    var lat = location['lat'].toString();
    var lng = location['lng'].toString();
    var link =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$origin_lat,$origin_lng&destinations=$lat%2C$lng&key=AIzaSyAPH5El5R_KCKFtJW7TOjwiyom5TaEG9f0";

    var url = Uri.parse(link);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        String duration_text =
            data['rows'][0]['elements'][0]['duration']['text'].toString();
        String distance_text =
            data['rows'][0]['elements'][0]['distance']['text'].toString();
        String distance_value =
            data['rows'][0]['elements'][0]['distance']['value'].toString();
        double amount = int.parse(distance_value) / 1000;
        double _amount = amount * 50;
        Map<String, dynamic> result = {
          'duration_text': duration_text,
          'distance_text': distance_text,
          'distance_value': _amount.ceil().toString(),
        };
        return result;
      } else {
        Map<String, dynamic> result = {
          'duration_text': '0min',
          'distance_text': '0km',
          'distance_value': '0'
        };
        return result;
      }
    } else {
      Map<String, dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
