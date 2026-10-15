import 'package:mt/features/home/data/datasources/product_title_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/product_title_entity.dart';
import 'package:mt/features/home/domain/repositories/product_title_repository.dart';

class ProductTitleRepositoryImpl implements ProductTitleRepository {
  final ProductTitleRemoteDataSource remoteDataSource;

  const ProductTitleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductTitleEntity>> getProductTitles() {
    return remoteDataSource.getProductTitles();
  }
}
