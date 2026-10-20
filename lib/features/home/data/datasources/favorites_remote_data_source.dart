import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/product_card_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class FavoritesRemoteDataSource {
  Future<Set<int>> getFavoriteProductIds();
  Future<List<ProductCardModel>> getFavoriteProducts({
    int limit = 10,
    int offset = 0,
  });
  Future<void> addFavorite(int productId);
  Future<void> removeFavorite(int productId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final SupabaseClient _client;
  static const _bucket = 'products';

  const FavoritesRemoteDataSourceImpl(this._client);

  String? _toPublicUrl(String? path) {
    return path != null
        ? _client.storage.from(_bucket).getPublicUrl(path)
        : null;
  }

  @override
  Future<Set<int>> getFavoriteProductIds() async {
    final response = await _client.from('favorites').select('product_id');
    return response.map((row) => row['product_id'] as int).toSet();
  }

  @override
  Future<List<ProductCardModel>> getFavoriteProducts({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _client.rpc(
        'get_my_favorites',
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
  Future<void> addFavorite(int productId) async {
    try {
      await _client.from('favorites').insert({'product_id': productId});
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<void> removeFavorite(int productId) async {
    await _client.from('favorites').delete().eq('product_id', productId);
  }
}
