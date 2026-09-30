import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseClient _client;
  static const _bucket = 'category_images';

  const CategoryRemoteDataSourceImpl(this._client);

  String _toPublicUrl(String path) {
    return _client.storage.from(_bucket).getPublicUrl(path);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select('id, name, slug, image_path');

      return (response as List)
          .map(
            (row) => CategoryModel.fromJson(
              row as Map<String, dynamic>,
              imageUrl: _toPublicUrl(row['image_path'] as String),
            ),
          )
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
