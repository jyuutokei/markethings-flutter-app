import 'package:mt/features/home/domain/entities/seller_product_entity.dart';

abstract class SellerProductRepository {
  Future<List<SellerProductEntity>> getSellerProductPage({
    required int limit,
    required int offset,
  });
  Future<void> setProductActive({
    required int productId,
    required bool isActive,
  });
  Future<void> deleteProduct({required int productId});
}
