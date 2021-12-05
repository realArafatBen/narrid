class ProductOverviewModel {
  final product_details;
  final specifications;

  ProductOverviewModel(this.product_details, this.specifications);

  factory ProductOverviewModel.fromJson(Map<String, dynamic> json) {
    final product_details = json['product_details'];
    final specifications = json['specifications'];
    return ProductOverviewModel(
        product_details, specifications);
  }
}
