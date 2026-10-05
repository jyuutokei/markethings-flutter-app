import 'package:equatable/equatable.dart';

class CartItemDetailsEntity extends Equatable {
  final int cartItemId;
  final int variantId;
  final String productTitle;
  final String variantName;
  final double price;
  final String? imageUrl;
  final int quantity;

  const CartItemDetailsEntity({
    required this.cartItemId,
    required this.variantId,
    required this.productTitle,
    required this.variantName,
    required this.price,
    this.imageUrl,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    cartItemId,
    variantId,
    productTitle,
    variantName,
    price,
    imageUrl,
    quantity,
  ];
}
