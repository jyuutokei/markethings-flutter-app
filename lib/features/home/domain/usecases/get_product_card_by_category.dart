import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/repositories/product_card_repository.dart';

class GetProductCardByCategory {
  final ProductCardRepository repository;

  const GetProductCardByCategory(this.repository);

  Future<List<ProductCardEntity>> call({
    required int categoryId,
    limit = 10,
    offset = 0,
  }) {
    return repository.getProductCardByCategory(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );
  }
}
