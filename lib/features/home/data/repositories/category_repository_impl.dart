import 'package:mt/features/home/data/datasources/category_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/category_entity.dart';
import 'package:mt/features/home/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  const CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CategoryEntity>> getCategories() {
    return remoteDataSource.getCategories();
  }
}
