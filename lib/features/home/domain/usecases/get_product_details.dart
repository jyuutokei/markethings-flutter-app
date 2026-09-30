import 'package:mt/features/home/domain/entities/product_details_entity.dart';
import 'package:mt/features/home/domain/repositories/product_details_repository.dart';

class GetProductDetails {
  final ProductDetailsRepository repository;

  const GetProductDetails(this.repository);

  Future<ProductDetailsEntity> call(int productId) {
    return repository.getProductDetail(productId);
  }
}
