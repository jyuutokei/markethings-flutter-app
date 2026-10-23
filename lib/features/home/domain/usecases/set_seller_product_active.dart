import 'package:mt/features/home/domain/repositories/seller_product_repository.dart';

class SetSellerProductActive {
  final SellerProductRepository repository;

  const SetSellerProductActive(this.repository);

  Future<void> call({required int productId, required bool isActive}) {
    return repository.setProductActive(
      productId: productId,
      isActive: isActive,
    );
  }
}
