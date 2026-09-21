import 'package:flutter/material.dart';
import 'package:mt/features/home/domain/entities/product.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.image,
    required super.title,
    required super.price,
    super.bgColor = const Color(0xFFEFEFF2),
    super.quantity = 1,
    super.isFavorite = false,
  });
}

List<ProductModel> demoProduct = [
  ProductModel(
    image: "assets/images/sample/product_0.png",
    title: "Long Sleeve Shirts",
    price: 165,
    bgColor: const Color(0xFFFEFBF9),
  ),
  ProductModel(
    image: "assets/images/sample/product_1.png",
    title: "Casual Henley Shirts",
    price: 99,
  ),
  ProductModel(
    image: "assets/images/sample/product_2.png",
    title: "Curved Hem Shirts",
    price: 180,
    bgColor: const Color(0xFFF8FEFB),
  ),
  ProductModel(
    image: "assets/images/sample/product_3.png",
    title: "Casual Nolin",
    price: 149,
    bgColor: const Color(0xFFEEEEED),
  ),
];
