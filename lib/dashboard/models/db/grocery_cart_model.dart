class GroceryCartHelper {
  final String id;
  final String product_name;
  final String quantity;
  final String price;
  final String image;
  final String shipping_cost;
  GroceryCartHelper({
    this.id,
    this.product_name,
    this.quantity,
    this.price,
    this.image,
    this.shipping_cost,
  });

  factory GroceryCartHelper.fromJson(Map<String, dynamic> json) {
    return GroceryCartHelper(id: json['productId']);
  }
}
