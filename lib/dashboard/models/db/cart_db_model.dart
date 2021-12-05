class CartHelper {
  final String id;
  final String product_name;
  final String quantity;
  final String variant;
  final String variantName;
  final String price;
  final String image;
  final String color;
  CartHelper({
    this.id,
    this.product_name,
    this.quantity,
    this.variant,
    this.variantName,
    this.price,
    this.image,
    this.color,
  });

  factory CartHelper.fromJson(Map<String, dynamic> json) {
    return CartHelper(id: json['productId']);
  }
}
