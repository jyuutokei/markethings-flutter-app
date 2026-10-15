import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/repositories/product_card_repository.dart';

class GetProductCardPage {
  final ProductCardRepository repository;

  const GetProductCardPage(this.repository);

  Future<List<ProductCardEntity>> call({int limit = 10, int offset = 0}) {
    return repository.getProductCardPage(limit: limit, offset: offset);
  }
}
