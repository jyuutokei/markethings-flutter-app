import 'dart:ui';

import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String image, title;
  final int price;
  final Color bgColor;

  const ProductEntity({
    required this.image,
    required this.title,
    required this.price,
    this.bgColor = const Color(0xFFEFEFF2),
  });

  @override
  List<Object?> get props => [image, title, price, bgColor];
}
