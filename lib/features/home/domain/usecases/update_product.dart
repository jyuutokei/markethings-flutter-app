import 'package:mt/features/home/domain/entities/create_product_input.dart';
import 'package:mt/features/home/domain/repositories/create_product_repository.dart';

class UpdateProduct {
  final CreateProductRepository repository;

  const UpdateProduct(this.repository);

  Future<int> call({required CreateProductInput input}) {
    return repository.updateProduct(input: input);
  }
}
