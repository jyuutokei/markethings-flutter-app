import 'package:equatable/equatable.dart';

class FavoritesEntity extends Equatable {
  final int id;
  final String userId;
  final int productId;
  final DateTime createdAt;

  const FavoritesEntity({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, productId, createdAt];
}
