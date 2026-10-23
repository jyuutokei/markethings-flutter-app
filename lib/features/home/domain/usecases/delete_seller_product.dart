import 'package:mt/features/home/domain/repositories/seller_product_repository.dart';

class DeleteSellerProduct {
  final SellerProductRepository repository;

  const DeleteSellerProduct(this.repository);

  Future<void> call({required int productId}) {
    return repository.deleteProduct(productId: productId);
  }
}
