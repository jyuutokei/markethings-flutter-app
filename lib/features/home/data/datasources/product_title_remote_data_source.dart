import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/product_title_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProductTitleRemoteDataSource {
  Future<List<ProductTitleModel>> getProductTitles();
}

class ProductTitleRemoteDataSourceImpl implements ProductTitleRemoteDataSource {
  final SupabaseClient _client;

  const ProductTitleRemoteDataSourceImpl(this._client);

  @override
  Future<List<ProductTitleModel>> getProductTitles() async {
    try {
      final response = await _client
          .from('products')
          .select('id, title')
          .limit(15);

      return (response as List)
          .map((row) => ProductTitleModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
