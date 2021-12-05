class BannersModel {
  final image;
  final type;
  final section;
  final url;
  final catId;

  BannersModel(
    this.image,
    this.catId,
    this.section,
    this.type,
    this.url,
  );

  factory BannersModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    final catId = json['catId'];
    final section = json['section'];
    final type = json['type'];
    final url = json['url'];

    return BannersModel(
      image,
      catId,
      section,
      type,
      url,
    );
  }
}
