import 'package:mt/features/home/domain/entities/product_title_entity.dart';
import 'package:mt/features/home/domain/repositories/product_title_repository.dart';

class GetProductTitles {
  final ProductTitleRepository repository;

  const GetProductTitles(this.repository);

  Future<List<ProductTitleEntity>> call() {
    return repository.getProductTitles();
  }
}
