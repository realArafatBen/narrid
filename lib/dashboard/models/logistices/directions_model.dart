import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDirections;
  final String totalDuration;
  final String directionValue;
  final String durationValue;

  Directions(
      {@required this.bounds,
      @required this.polylinePoints,
      @required this.totalDirections,
      @required this.totalDuration,
      @required this.directionValue,
      @required this.durationValue});

  factory Directions.fromMap(Map<String, dynamic> map) {
    //check if route is not avaiable
    if ((map['routes'] as List).isEmpty) return null;

    //get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    //bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );
    //Distance & Duration
    String distance = '';
    String duration = '';
    //values
    String distancevalue = '';
    String durationvalue = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
      //values
      distancevalue = leg['distance']['value'].toString();
      durationvalue = leg['duration']['value'].toString();
    }

    return Directions(
      bounds: bounds,
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDirections: distance,
      totalDuration: duration,
      directionValue: distancevalue,
      durationValue: durationvalue,
    );
  }
}
