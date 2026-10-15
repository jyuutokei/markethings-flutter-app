import 'package:mt/features/home/domain/entities/product_card_entity.dart';

abstract class ProductCardRepository {
  Future<List<ProductCardEntity>> getProductCardDetails([int? limit]);
  Future<List<ProductCardEntity>> getProductCardPage({
    int limit = 10,
    int offset = 0,
  });
}
