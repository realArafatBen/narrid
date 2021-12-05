class ProductDetailsModel {
  final store_name;
  final product_name;
  final brand_name;
  final price;
  final discount_price;

  ProductDetailsModel(this.store_name, this.product_name, this.brand_name,
      this.price, this.discount_price);

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final store_name = json['store_name'];
    final product_name = json['name'];
    final brand_name = json['brand_name'];
    final price = json['product_price'];
    final discount_price = json['discount_price'];
    return ProductDetailsModel(
        store_name, product_name, brand_name, price, discount_price);
  }
}
