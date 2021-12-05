class DeliveryOtherDetailsModel {
  final details;
  final isDiscount;
  final returns;
  final warranty;
  final store_name;
  final storeId;

  DeliveryOtherDetailsModel(
    this.details,
    this.isDiscount,
    this.returns,
    this.warranty,
    this.store_name,
    this.storeId,
  );

  factory DeliveryOtherDetailsModel.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    final isDiscount = json['isDiscount'];
    final returns = json['returns'];
    final warranty = json['warranty'];
    final store_name = json['store_name'];
    final storeId = json['storeId'];

    return DeliveryOtherDetailsModel(
      details,
      isDiscount,
      returns,
      warranty,
      store_name,
      storeId,
    );
  }
}
