import 'package:equatable/equatable.dart';

class CartItemAddEntity extends Equatable {
  final int id;
  final String userId;
  final int variantId;

  const CartItemAddEntity({
    required this.id,
    required this.userId,
    required this.variantId,
  });

  @override
  List<Object?> get props => [id, userId, variantId];
}
