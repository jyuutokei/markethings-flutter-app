import 'package:mt/features/home/domain/entities/create_product_input.dart';
import 'package:mt/features/home/domain/repositories/create_product_repository.dart';

class SubmitProduct {
  final CreateProductRepository repository;

  const SubmitProduct(this.repository);

  Future<int> call({required CreateProductInput input}) {
    return repository.submitProduct(input: input);
  }
}
