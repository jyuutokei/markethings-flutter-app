import 'package:mt/features/home/data/datasources/favorites_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  const FavoritesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Set<int>> getFavoriteProductIds() {
    return remoteDataSource.getFavoriteProductIds();
  }

  @override
  Future<List<ProductCardEntity>> getFavoriteProducts({
    int limit = 10,
    int offset = 0,
  }) {
    return remoteDataSource.getFavoriteProducts(limit: limit, offset: offset);
  }

  @override
  Future<void> addFavorite(int productId) {
    return remoteDataSource.addFavorite(productId);
  }

  @override
  Future<void> removeFavorite(int productId) {
    return remoteDataSource.removeFavorite(productId);
  }
}
