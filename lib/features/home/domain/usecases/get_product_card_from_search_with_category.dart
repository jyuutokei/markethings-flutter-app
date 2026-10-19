import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/repositories/product_card_repository.dart';

class GetProductCardFromSearchWithCategory {
  final ProductCardRepository repository;

  const GetProductCardFromSearchWithCategory(this.repository);

  Future<List<ProductCardEntity>> call({
    required int categoryId,
    required String query,
    limit = 10,
    offset = 0,
  }) {
    return repository.getProductCardFromSearchWithCategory(
      categoryId: categoryId,
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
