import 'dart:typed_data';

class CreateProductInput {
  final String title;
  final int categoryId;
  final String? description;
  final Uint8List? mainImageBytes;
  final List<CreateProductVariantInput> variants;

  const CreateProductInput({
    required this.title,
    required this.categoryId,
    required this.description,
    required this.mainImageBytes,
    required this.variants,
  });
}

class CreateProductVariantInput {
  final String name;
  final double price;
  final int stockQuantity;
  final Uint8List? imageBytes;

  const CreateProductVariantInput({
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.imageBytes,
  });
}
