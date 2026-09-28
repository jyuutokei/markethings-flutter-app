import 'package:mt/features/home/domain/entities/product_card_entity.dart';

class ProductCardModel extends ProductCardEntity {
  const ProductCardModel({
    required super.id,
    required super.title,
    super.mainImageUrl,
    required super.price,
    required super.createdAt,
  });

  factory ProductCardModel.fromJson(Map<String, dynamic> json) {
    return ProductCardModel(
      id: json['id'] as int,
      title: json['title'] as String,
      mainImageUrl: json['main_image_url'] as String?,
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
