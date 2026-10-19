import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/repositories/product_card_repository.dart';

class GetProductCardFromSearch {
  final ProductCardRepository repository;

  const GetProductCardFromSearch(this.repository);

  Future<List<ProductCardEntity>> call({
    required String query,
    limit = 10,
    offset = 0,
  }) {
    return repository.getProductCardFromSearch(
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
