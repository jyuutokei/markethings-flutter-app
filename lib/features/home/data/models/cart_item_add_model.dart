import 'package:mt/features/home/domain/entities/cart_item_add_entity.dart';

class CartItemAddModel extends CartItemAddEntity {
  const CartItemAddModel({
    required super.id,
    required super.userId,
    required super.variantId,
    required super.quantity,
  });

  factory CartItemAddModel.fromJson(Map<String, dynamic> json) {
    return CartItemAddModel(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      variantId: (json['variant_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
    );
  }
}
