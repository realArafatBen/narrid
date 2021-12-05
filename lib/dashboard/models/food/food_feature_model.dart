import 'package:flutter/cupertino.dart';

class FeatureFoodModel {
  final store_name;
  final city;
  final lat;
  final lng;
  final id;
  final image;
  final name;
  final price;

  FeatureFoodModel({
    @required this.store_name,
    @required this.city,
    @required this.lat,
    @required this.lng,
    @required this.id,
    @required this.image,
    @required this.name,
    @required this.price,
  });

  factory FeatureFoodModel.fromJson(Map<String, dynamic> json) {
    final store_name = json['store_name'];
    final city = json['city'];
    final lat = json['lat'];
    final lng = json['lng'];
    final image = json['_image'];
    final name = json['name'];
    final price = json['price'];
    final id = json['id'];
    return FeatureFoodModel(
      store_name: store_name,
      city: city,
      lat: lat,
      lng: lng,
      image: image,
      name: name,
      price: price,
      id: id,
    );
  }
}
