import 'package:equatable/equatable.dart';

class VariantEntity extends Equatable {
  final int id;
  final int productId;
  final String name;
  final double price;
  final String? imageUrl;
  final String? imagePath;
  final int stockQuantity;
  final Map<String, dynamic> attributes;

  const VariantEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.imagePath,
    required this.stockQuantity,
    required this.attributes,
  });

  @override
  List<Object?> get props => [
    name,
    price,
    ?imageUrl,
    ?imagePath,
    stockQuantity,
    attributes,
  ];
}

class ProductDetailsEntity extends Equatable {
  final int id;
  final int categoryId;
  final String sellerId;
  final String title;
  final String? description;
  final String? mainImageUrl;
  final String? mainImagePath;
  final List<VariantEntity> variants; // the grouped array
  final String sellerDisplayName;
  final String? sellerStoreName;

  const ProductDetailsEntity({
    required this.id,
    required this.categoryId,
    required this.sellerId,
    required this.title,
    this.description,
    this.mainImageUrl,
    this.mainImagePath,
    required this.variants,
    required this.sellerDisplayName,
    this.sellerStoreName,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    categoryId,
    sellerId,
    ?description,
    ?mainImageUrl,
    ?mainImagePath,
    variants,
    sellerDisplayName,
    ?sellerStoreName,
  ];
}
