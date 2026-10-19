import 'package:mt/features/home/domain/repositories/favorites_repository.dart';

class ToggleFavorite {
  final FavoritesRepository repository;

  const ToggleFavorite(this.repository);

  Future<void> call(int productId, {required bool isCurrentlyFavorite}) {
    return isCurrentlyFavorite
        ? repository.addFavorite(productId)
        : repository.removeFavorite(productId);
  }
}
