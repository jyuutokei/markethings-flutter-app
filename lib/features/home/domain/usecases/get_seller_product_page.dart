import 'package:mt/features/home/domain/entities/seller_product_entity.dart';
import 'package:mt/features/home/domain/repositories/seller_product_repository.dart';

class GetSellerProductPage {
  final SellerProductRepository repository;

  const GetSellerProductPage(this.repository);

  Future<List<SellerProductEntity>> call({
    required int limit,
    required int offset,
  }) {
    return repository.getSellerProductPage(limit: limit, offset: offset);
  }
}
