class FoodCartHelper {
  final String id;
  final String product_name;
  final String quantity;
  final String price;
  final String image;
  final String shipping_cost;
  FoodCartHelper({
    this.id,
    this.product_name,
    this.quantity,
    this.price,
    this.image,
    this.shipping_cost,
  });

  factory FoodCartHelper.fromJson(Map<String, dynamic> json) {
    return FoodCartHelper(id: json['productId']);
  }
}
