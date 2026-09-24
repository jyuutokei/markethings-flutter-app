import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final int categoryId;
  final String sellerId;
  final String title;
  final String? description;
  final String? mainImageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    required this.id,
    required this.categoryId,
    required this.sellerId,
    required this.title,
    this.description,
    this.mainImageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [
    id,
    categoryId,
    sellerId,
    title,
    ?description,
    ?mainImageUrl,
    isActive,
    createdAt,
    updatedAt,
  ];
}
