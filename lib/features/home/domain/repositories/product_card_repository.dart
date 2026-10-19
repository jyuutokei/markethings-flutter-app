import 'package:mt/features/home/domain/entities/product_card_entity.dart';

abstract class ProductCardRepository {
  Future<List<ProductCardEntity>> getProductCardDetails([int? limit]);
  Future<List<ProductCardEntity>> getProductCardPage({
    int limit = 10,
    int offset = 0,
  });
  Future<List<ProductCardEntity>> getProductCardFromSearch({
    required String query,
    int limit = 10,
    int offset = 0,
  });
  Future<List<ProductCardEntity>> getProductCardByCategory({
    required int categoryId,
    int limit = 10,
    int offset = 0,
  });
  Future<List<ProductCardEntity>> getProductCardFromSearchWithCategory({
    required int categoryId,
    required String query,
    int limit = 10,
    int offset = 0,
  });
}
