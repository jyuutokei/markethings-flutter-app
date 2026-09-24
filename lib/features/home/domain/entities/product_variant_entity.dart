import 'package:equatable/equatable.dart';

class ProductVariantEntity extends Equatable {
  final int id;
  final int productId;
  final String name;
  final String sku;
  final double price; // numeric(10,2) -> double
  final int stockQuantity;
  final String? imageUrl;
  final Map<String, dynamic> attributes; // jsonb
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductVariantEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.sku,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
    required this.attributes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    sku,
    price,
    stockQuantity,
    imageUrl,
    attributes,
    createdAt,
    updatedAt,
  ];
}
