import 'package:equatable/equatable.dart';

class ProductCardEntity extends Equatable {
  final int id;
  final String title;
  final int categoryId;
  final String sellerId;
  final String? mainImageUrl;
  final double price;
  final DateTime createdAt;

  const ProductCardEntity({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.sellerId,
    this.mainImageUrl,
    required this.price,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
    id,
    title,
    categoryId,
    sellerId,
    ?mainImageUrl,
    price,
  ];
}
