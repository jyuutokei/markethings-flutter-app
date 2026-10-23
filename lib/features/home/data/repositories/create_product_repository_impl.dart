import 'package:mt/features/home/data/datasources/create_product_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/create_product_input.dart';
import 'package:mt/features/home/domain/repositories/create_product_repository.dart';

class CreateProductRepositoryImpl implements CreateProductRepository {
  final CreateProductRemoteDataSource remoteDataSource;

  const CreateProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<int> submitProduct({required CreateProductInput input}) {
    return remoteDataSource.submitProduct(input: input);
  }

  @override
  Future<int> updateProduct({required CreateProductInput input}) {
    return remoteDataSource.updateProduct(input: input);
  }
}
