import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/product_card_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProductCardRemoteDataSource {
  Future<List<ProductCardModel>> getProductCardDetails([int? limit]);
  Future<List<ProductCardModel>> getProductCardPage({
    int limit = 10,
    int offset = 0,
  });
}

class ProductCardRemoteDataSourceImpl implements ProductCardRemoteDataSource {
  final SupabaseClient _client;

  const ProductCardRemoteDataSourceImpl(this._client);

  @override
  Future<List<ProductCardModel>> getProductCardDetails([int? limit]) async {
    try {
      final response = await _client.rpc(
        'get_product_card_details',
        params: {'_limit': limit},
      );

      return (response as List)
          .map((row) => ProductCardModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<List<ProductCardModel>> getProductCardPage({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _client.rpc(
        'get_product_card_page',
        params: {'_limit': limit, '_offset': offset},
      );

      return (response as List)
          .map((row) => ProductCardModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
