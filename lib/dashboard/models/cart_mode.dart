import 'package:flutter/cupertino.dart';

class CartModel {
  final String id;
  final String image;
  final String productName;
  final String price;
  final String variant;

  CartModel(
      {@required this.id,
      @required this.image,
      @required this.productName,
      @required this.price,
      @required this.variant});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final id = json['image'];
    final image = json['name'];
    final productName = json['id'];
    final price = json['price'];
    final variant = json['variant'];

    return CartModel(
        id: id,
        image: image,
        productName: productName,
        price: price,
        variant: variant);
  }
}
