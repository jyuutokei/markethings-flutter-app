import 'package:mt/features/home/domain/entities/product_details_entity.dart';

class VariantModel extends VariantEntity {
  const VariantModel({
    required super.name,
    required super.price,
    super.imageUrl,
    required super.stockQuantity,
    required super.attributes,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      stockQuantity: json['stock_quantity'] as int,
      attributes: Map<String, dynamic>.from(json['attributes'] as Map),
    );
  }
}

class ProductDetailsModel extends ProductDetailsEntity {
  const ProductDetailsModel({
    required super.id,
    required super.title,
    super.description,
    super.mainImageUrl,
    required super.variants,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      mainImageUrl: json['main_image_url'] as String?,
      variants: (json['product_variants'] as List)
          .map((v) => VariantModel.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}
