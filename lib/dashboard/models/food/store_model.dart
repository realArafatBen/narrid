import 'package:flutter/cupertino.dart';

class StoreFoodModel {
  final name;
  final image;
  final store;
  final lat;
  final lng;
  final id;
  final city;

  StoreFoodModel(
      {@required this.id,
      @required this.name,
      @required this.image,
      @required this.store,
      @required this.lat,
      @required this.lng,
      @required this.city});

  factory StoreFoodModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final image = json['_image'];
    final store = json['store'];
    final lat = json['lat'];
    final lng = json['lng'];
    final city = json['city'];

    return StoreFoodModel(
      id: id,
      name: name,
      image: image,
      store: store,
      lat: lat,
      lng: lng,
      city: city,
    );
  }
}
