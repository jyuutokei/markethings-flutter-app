import 'package:mt/features/home/domain/entities/favorites_entity.dart';

class FavoritesModel extends FavoritesEntity {
  const FavoritesModel({
    required super.id,
    required super.userId,
    required super.productId,
    required super.createdAt,
  });

  factory FavoritesModel.fromJson(Map<String, dynamic> json) {
    return FavoritesModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      productId: json['product_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
