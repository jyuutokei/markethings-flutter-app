import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/repositories/product_card_repository.dart';

class GetProductCardDetails {
  final ProductCardRepository repository;

  const GetProductCardDetails(this.repository);

  Future<List<ProductCardEntity>> call([int? limit]) {
    return repository.getProductCardDetails(limit);
  }
}
