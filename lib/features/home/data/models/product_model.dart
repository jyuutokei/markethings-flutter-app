import 'package:mt/features/home/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.categoryId,
    required super.sellerId,
    required super.title,
    super.description,
    super.mainImageUrl,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      categoryId: json['category_id'] as int,
      sellerId: json['seller_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      mainImageUrl: json['main_image_url'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'seller_id': sellerId,
      'title': title,
      'description': description,
      'main_image_url': mainImageUrl,
      'is_active': isActive,
    };
  }
}
