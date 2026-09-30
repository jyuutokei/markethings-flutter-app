import 'package:equatable/equatable.dart';

class VariantEntity extends Equatable {
  final String name;
  final double price;
  final String? imageUrl;
  final int stockQuantity;
  final Map<String, dynamic> attributes;

  const VariantEntity({
    required this.name,
    required this.price,
    this.imageUrl,
    required this.stockQuantity,
    required this.attributes,
  });

  @override
  List<Object?> get props => [
    name,
    price,
    ?imageUrl,
    stockQuantity,
    attributes,
  ];
}

class ProductDetailsEntity extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String? mainImageUrl;
  final List<VariantEntity> variants; // the grouped array

  const ProductDetailsEntity({
    required this.id,
    required this.title,
    this.description,
    this.mainImageUrl,
    required this.variants,
  });

  @override
  List<Object?> get props => [id, title, ?description, ?mainImageUrl, variants];
}
