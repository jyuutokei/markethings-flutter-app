import '../../domain/entities/product_variant_entity.dart';

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.sku,
    required super.price,
    required super.stockQuantity,
    super.imageUrl,
    required super.attributes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      name: json['name'] as String,
      sku: json['sku'] as String,
      // supabase can hand numeric back as int or double depending on value
      // num.toDouble() covers both safely.
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stock_quantity'] as int,
      imageUrl: json['image_url'] as String?,
      attributes: Map<String, dynamic>.from(json['attributes'] as Map),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'sku': sku,
      'price': price,
      'stock_quantity': stockQuantity,
      'image_url': imageUrl,
      'attributes': attributes,
    };
  }
}
