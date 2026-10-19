import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/repositories/favorites_repository.dart';

class GetFavoriteProducts {
  final FavoritesRepository repository;

  const GetFavoriteProducts(this.repository);

  Future<List<ProductCardEntity>> call({int limit = 10, int offset = 0}) async {
    return repository.getFavoriteProducts(limit: limit, offset: offset);
  }
}
