import 'dart:ui';

import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String image, title;
  final num price;
  final int quantity;
  final Color bgColor;

  const ProductEntity({
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
    this.bgColor = const Color(0xFFEFEFF2),
  });

  ProductEntity quantityAdd() {
    return copyWith(quantity: quantity + 1);
  }

  ProductEntity quantityReduce() {
    if (quantity < 1) {
      throw Exception("Quantity can't be zero");
    }
    return copyWith(quantity: quantity - 1);
  }

  ProductEntity copyWith({int? quantity}) {
    return ProductEntity(
      image: image,
      title: title,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [image, title, price, bgColor];
}
