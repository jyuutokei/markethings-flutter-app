import 'package:mt/features/home/domain/entities/create_product_input.dart';

abstract class CreateProductRepository {
  Future<int> submitProduct({required CreateProductInput input});
  Future<int> updateProduct({required CreateProductInput input});
}
