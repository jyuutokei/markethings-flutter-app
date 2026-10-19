import 'package:mt/features/home/domain/entities/product_card_entity.dart';

abstract class FavoritesRepository {
  Future<Set<int>> getFavoriteProductIds();
  Future<List<ProductCardEntity>> getFavoriteProducts({
    int limit = 10,
    int offset = 0,
  });
  Future<void> addFavorite(int productId);
  Future<void> removeFavorite(int productId);
}
