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

  @override
  Future<List<ProductCardEntity>> getProductCardPage({
    int limit = 10,
    int offset = 0,
  }) {
    return remoteDataSource.getProductCardPage(limit: limit, offset: offset);
  }

  @override
  Future<List<ProductCardEntity>> getProductCardFromSearch({
    required String query,
    int limit = 10,
    int offset = 0,
  }) {
    return remoteDataSource.getProductCardFromSearch(
      query: query,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<ProductCardEntity>> getProductCardByCategory({
    required int categoryId,
    int limit = 10,
    int offset = 0,
  }) {
    return remoteDataSource.getProductCardByCategory(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<ProductCardEntity>> getProductCardFromSearchWithCategory({
    required int categoryId,
    required String query,
    int limit = 10,
    int offset = 0,
  }) {
    return remoteDataSource.getProductCardFromSearchWithCategory(
      categoryId: categoryId,
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
