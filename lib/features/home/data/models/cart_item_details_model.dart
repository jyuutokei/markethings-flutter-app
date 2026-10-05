import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';

class CartItemDetailsModel extends CartItemDetailsEntity {
  const CartItemDetailsModel({
    required super.cartItemId,
    required super.variantId,
    required super.productTitle,
    required super.variantName,
    required super.price,
    super.imageUrl,
    required super.quantity,
  });

  factory CartItemDetailsModel.fromJson(Map<String, dynamic> json) {
    final variant = Map<String, dynamic>.from(json['variant'] as Map);
    final product = Map<String, dynamic>.from(variant['product'] as Map);

    return CartItemDetailsModel(
      cartItemId: json['id'] as int,
      variantId: json['variant_id'] as int,
      productTitle: product['title'] as String,
      variantName: variant['name'] as String,
      price: (variant['price'] as num).toDouble(),
      imageUrl: variant['image_url'] as String?,
      quantity: json['quantity'] as int,
    );
  }
}
