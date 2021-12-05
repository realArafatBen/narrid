class OrderProductModel {
  final name;
  final id;
  final price;
  final qty;

  OrderProductModel(
    this.name,
    this.id,
    this.price,
    this.qty,
  );

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    final name = json['product_name'];
    final id = json['product_id'];
    final price = json['subtotal'];
    final qty = json['quantity'];

    return OrderProductModel(name, id, price, qty);
  }
}
