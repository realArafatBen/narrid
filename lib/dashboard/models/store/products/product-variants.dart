class ProductVariantsModel {
  final id;
  final size;
  final price;
  final discount;

  ProductVariantsModel(this.id, this.size, this.price, this.discount);

  factory ProductVariantsModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final size = json['size'];
    final price = json['price'];
    final discount = json['discount_price'];
    return ProductVariantsModel(id, size, price, discount);
  }
}
