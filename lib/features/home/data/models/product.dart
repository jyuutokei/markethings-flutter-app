import 'package:flutter/material.dart';
import 'package:mt/features/home/domain/entities/product.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.image,
    required super.title,
    required super.price,
    super.bgColor = const Color(0xFFEFEFF2),
  });
}

List<ProductModel> demoProduct = [
  const ProductModel(
    image: "assets/images/product_0.png",
    title: "Long Sleeve Shirts",
    price: 165,
    bgColor: Color(0xFFFEFBF9),
  ),
  const ProductModel(
    image: "assets/images/product_1.png",
    title: "Casual Henley Shirts",
    price: 99,
  ),
  const ProductModel(
    image: "assets/images/product_2.png",
    title: "Curved Hem Shirts",
    price: 180,
    bgColor: Color(0xFFF8FEFB),
  ),
  const ProductModel(
    image: "assets/images/product_3.png",
    title: "Casual Nolin",
    price: 149,
    bgColor: Color(0xFFEEEEED),
  ),
];
