import 'dart:typed_data';

class CreateProductInput {
  final int? productId;
  final String title;
  final int categoryId;
  final String? description;
  final Uint8List? mainImageBytes;
  final String? mainImagePath;
  final List<CreateProductVariantInput> variants;

  const CreateProductInput({
    this.productId,
    required this.title,
    required this.categoryId,
    required this.description,
    required this.mainImageBytes,
    required this.mainImagePath,
    required this.variants,
  });
}

class CreateProductVariantInput {
  final int? variantId;
  final String name;
  final double price;
  final int stockQuantity;
  final Uint8List? imageBytes;
  final String? imagePath;

  const CreateProductVariantInput({
    this.variantId,
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.imageBytes,
    required this.imagePath,
  });
}
