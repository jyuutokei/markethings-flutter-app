import 'package:flutter/material.dart';
import 'package:mt/features/home/presentation/widgets/create_product_picked_image.dart';

class CreateProductVariantFields {
  int? variantId;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController(text: '0');
  CreateProductPickedImage? image;

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}
