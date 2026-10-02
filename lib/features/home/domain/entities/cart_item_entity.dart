import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final int id;
  final String userId;
  final int variantId;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartItemEntity({
    required this.id,
    required this.userId,
    required this.variantId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    variantId,
    quantity,
    createdAt,
    updatedAt,
  ];
}
