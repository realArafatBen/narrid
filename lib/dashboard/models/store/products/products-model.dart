class ProductsModel {
  final image;
  final name;
  final id;
  final price;
  final discount;
  final isOff;
  final off;
  final shipping;
  final details;
  final ratings;
  final orders;
  final extras;
  final extimate;
  ProductsModel(
    this.image,
    this.name,
    this.id,
    this.price,
    this.discount,
    this.isOff,
    this.off,
    this.shipping,
    this.details,
    this.ratings,
    this.orders,
    this.extras,
    this.extimate,
  );

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    final name = json['name'];
    final id = json['id'];
    final price = json['price'];
    final discount = json['discount'];
    final shipping = json['shipping'];
    final details = json['details'];
    final isOff = json['isOff'];
    final off = json['off'];
    final ratings = json['ratings'];
    final orders = json['orders'];
    final extras = json['extras'];
    final extimate = json['extimate'];
    return ProductsModel(
      image,
      name,
      id,
      price,
      discount,
      isOff,
      off,
      shipping,
      details,
      ratings,
      orders,
      extras,
      extimate,
    );
  }
}
