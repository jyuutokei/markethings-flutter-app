import 'package:mt/features/home/domain/entities/seller_product_entity.dart';

class SellerProductModel extends SellerProductEntity {
  const SellerProductModel({
    required super.id,
    required super.title,
    required super.sellerId,
    required super.mainImageUrl,
    required super.price,
    required super.isActive,
  });

  factory SellerProductModel.fromJson(
    Map<String, dynamic> json, {
    required String? imageUrl,
  }) {
    final variants = json['variants'] as List;
    if (variants.isEmpty) {
      throw const FormatException('Seller product has no variants.');
    }

    final lowestPrice = variants.fold<double>(double.infinity, (
      lowest,
      variant,
    ) {
      final variantJson = Map<String, dynamic>.from(variant as Map);
      final price = (variantJson['price'] as num).toDouble();
      return price < lowest ? price : lowest;
    });

    return SellerProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      sellerId: json['seller_id'] as String,
      mainImageUrl: imageUrl,
      price: lowestPrice,
      isActive: json['is_active'] as bool,
    );
  }
}
