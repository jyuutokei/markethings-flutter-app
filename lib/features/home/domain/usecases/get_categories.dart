import 'package:mt/features/home/domain/entities/category_entity.dart';
import 'package:mt/features/home/domain/repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  const GetCategories(this.repository);

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}
