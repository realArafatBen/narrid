import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/models/logistices/directions_model.dart';

class DirectionRepository {
  Future<Directions> getDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    var link =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyBIgZP9pMhvjCCen9THQLMGG3vOxKoEldA";

    var url = Uri.parse(link);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return Directions.fromMap(data);
    } else {
      Directions error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
