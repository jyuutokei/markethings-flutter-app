import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/product_card_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProductCardRemoteDataSource {
  Future<List<ProductCardModel>> getProductCardDetails([int? limit]);
  Future<List<ProductCardModel>> getProductCardPage({
    int limit = 10,
    int offset = 0,
  });
  Future<List<ProductCardModel>> getProductCardFromSearch({
    required String query,
    int limit = 10,
    int offset = 0,
  });
  Future<List<ProductCardModel>> getProductCardByCategory({
    required int categoryId,
    int limit = 10,
    int offset = 0,
  });
  Future<List<ProductCardModel>> getProductCardFromSearchWithCategory({
    required int categoryId,
    required String query,
    int limit = 10,
    int offset = 0,
  });
}

class ProductCardRemoteDataSourceImpl implements ProductCardRemoteDataSource {
  final SupabaseClient _client;
  static const _bucket = 'products';

  const ProductCardRemoteDataSourceImpl(this._client);

  String? _toPublicUrl(String? path) {
    return path != null
        ? _client.storage.from(_bucket).getPublicUrl(path)
        : null;
  }

  @override
  Future<List<ProductCardModel>> getProductCardDetails([int? limit]) async {
    try {
      final response = await _client.rpc(
        'get_product_card_details',
        params: {'_limit': limit},
      );

      return (response as List)
          .map(
            (row) => ProductCardModel.fromJson(
              row as Map<String, dynamic>,
              imageUrl: _toPublicUrl(row['main_image_url'] as String?),
            ),
          )
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
          .map(
            (row) => ProductCardModel.fromJson(
              row as Map<String, dynamic>,
              imageUrl: _toPublicUrl(row['main_image_url'] as String?),
            ),
          )
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<List<ProductCardModel>> getProductCardFromSearch({
    required String query,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _client.rpc(
        'search_products',
        params: {'_limit': limit, 'search_term': query, '_offset': offset},
      );

      return (response as List)
          .map(
            (row) => ProductCardModel.fromJson(
              row as Map<String, dynamic>,
              imageUrl: _toPublicUrl(row['main_image_url'] as String?),
            ),
          )
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<List<ProductCardModel>> getProductCardByCategory({
    required int categoryId,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _client.rpc(
        'get_products_by_category',
        params: {
          'category_id_param': categoryId,
          '_limit': limit,
          '_offset': offset,
        },
      );

      return (response as List)
          .map(
            (row) => ProductCardModel.fromJson(
              row as Map<String, dynamic>,
              imageUrl: _toPublicUrl(row['main_image_url'] as String?),
            ),
          )
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<List<ProductCardModel>> getProductCardFromSearchWithCategory({
    required int categoryId,
    required String query,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _client.rpc(
        'search_products_with_category',
        params: {
          '_limit': limit,
          'category_id_param': categoryId,
          'search_term': query,
          '_offset': offset,
        },
      );

      return (response as List)
          .map(
            (row) => ProductCardModel.fromJson(
              row as Map<String, dynamic>,
              imageUrl: _toPublicUrl(row['main_image_url'] as String?),
            ),
          )
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
