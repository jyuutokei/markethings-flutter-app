import 'dart:ui';

import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String image, title;
  final num price;
  final Color bgColor;
  int quantity;
  bool isFavorite;

  ProductEntity({
    required this.image,
    required this.title,
    required this.price,
    required this.bgColor,
    required this.quantity,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [image, title, price, bgColor];
}
