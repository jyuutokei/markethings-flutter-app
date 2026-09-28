import 'package:mt/features/home/data/datasources/product_card_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/repositories/product_card_repository.dart';

class ProductCardRepositoryImpl implements ProductCardRepository {
  final ProductCardRemoteDataSource remoteDataSource;

  const ProductCardRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductCardEntity>> getProductCardDetails([int? limit]) {
    return remoteDataSource.getProductCardDetails(limit);
  }
}
