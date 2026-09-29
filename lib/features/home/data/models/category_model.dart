import 'package:mt/features/home/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.imageUrl,
  });

  factory CategoryModel.fromJson(
    Map<String, dynamic> json, {
    required String? imageUrl,
  }) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      imageUrl: imageUrl,
    );
  }
}
