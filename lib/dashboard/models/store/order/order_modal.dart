import 'package:flutter/cupertino.dart';

class OrderModel {
  final ref;
  final grand_total;
  final id;
  final payment_status;
  final sale_status;
  final delivery_status;
  final total;
  final delivery;

  OrderModel({
    @required this.id,
    @required this.payment_status,
    @required this.ref,
    @required this.sale_status,
    @required this.total,
    @required this.delivery_status,
    @required this.delivery,
    @required this.grand_total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final ref = json['reference_no'];
    final total = json['total'];
    final id = json['id'];
    final payment_status = json['payment_status'];
    final sale_status = json['sale_status'];
    final delivery_status = json['delivery_status'];
    final delivery = json['delivery'];
    final grand_total = json['grand_total'];

    return OrderModel(
      id: id,
      payment_status: payment_status,
      ref: ref,
      sale_status: sale_status,
      total: total,
      delivery_status: delivery_status,
      delivery: delivery,
      grand_total: grand_total,
    );
  }
}
