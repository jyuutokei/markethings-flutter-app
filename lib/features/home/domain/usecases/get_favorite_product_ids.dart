import 'package:mt/features/home/domain/repositories/favorites_repository.dart';

class GetFavoriteProductIds {
  final FavoritesRepository repository;

  const GetFavoriteProductIds(this.repository);

  Future<Set<int>> call() async {
    return repository.getFavoriteProductIds();
  }
}
