class CategoriesModel {
  final image;
  final name;
  final id;

  CategoriesModel(this.image, this.name, this.id);

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    final name = json['name'];
    final id = json['id'];

    return CategoriesModel(image, name, id);
  }
}
