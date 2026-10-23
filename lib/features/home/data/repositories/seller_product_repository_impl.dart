import 'package:mt/features/home/data/datasources/seller_product_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/seller_product_entity.dart';
import 'package:mt/features/home/domain/repositories/seller_product_repository.dart';

class SellerProductRepositoryImpl implements SellerProductRepository {
  final SellerProductRemoteDataSource remoteDataSource;

  const SellerProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SellerProductEntity>> getSellerProductPage({
    required int limit,
    required int offset,
  }) {
    return remoteDataSource.getSellerProductPage(limit: limit, offset: offset);
  }

  @override
  Future<void> setProductActive({
    required int productId,
    required bool isActive,
  }) {
    return remoteDataSource.setProductActive(
      productId: productId,
      isActive: isActive,
    );
  }

  @override
  Future<void> deleteProduct({required int productId}) {
    return remoteDataSource.deleteProduct(productId: productId);
  }
}
