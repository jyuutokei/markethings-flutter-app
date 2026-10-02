import 'package:mt/features/home/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.userId,
    required super.variantId,
    required super.quantity,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      variantId: (json['variant_id'] as num).toInt(),
      quantity: json['quantity'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
