import 'package:mt/features/home/data/datasources/product_details_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/product_details_entity.dart';
import 'package:mt/features/home/domain/repositories/product_details_repository.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;

  const ProductDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductDetailsEntity> getProductDetail(int productId) {
    return remoteDataSource.getProductDetail(productId);
  }
}
