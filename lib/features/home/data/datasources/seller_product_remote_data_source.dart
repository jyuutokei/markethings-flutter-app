import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/seller_product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SellerProductRemoteDataSource {
  Future<List<SellerProductModel>> getSellerProductPage({
    required int limit,
    required int offset,
  });
  Future<void> setProductActive({
    required int productId,
    required bool isActive,
  });
  Future<void> deleteProduct({required int productId});
}

class SellerProductRemoteDataSourceImpl
    implements SellerProductRemoteDataSource {
  final SupabaseClient _client;
  static const _bucket = 'products';

  const SellerProductRemoteDataSourceImpl(this._client);

  String? _toPublicUrl(String? path) {
    return path == null
        ? null
        : _client.storage.from(_bucket).getPublicUrl(path);
  }

  @override
  Future<List<SellerProductModel>> getSellerProductPage({
    required int limit,
    required int offset,
  }) async {
    final sellerId = _client.auth.currentUser?.id;
    if (sellerId == null) {
      throw StateError('A signed-in user is required to view seller products.');
    }

    try {
      final rows = await _client
          .from('products')
          .select(
            'id, title, seller_id, main_image_url, is_active, '
            'variants:product_variants!inner(price)',
          )
          .eq('seller_id', sellerId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (rows as List)
          .map((row) {
            final json = Map<String, dynamic>.from(row as Map);
            return SellerProductModel.fromJson(
              json,
              imageUrl: _toPublicUrl(json['main_image_url'] as String?),
            );
          })
          .toList(growable: false);
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<void> setProductActive({
    required int productId,
    required bool isActive,
  }) async {
    final sellerId = _client.auth.currentUser?.id;
    if (sellerId == null) {
      throw StateError('A signed-in user is required to update a product.');
    }

    try {
      final updated = await _client
          .from('products')
          .update({'is_active': isActive})
          .eq('id', productId)
          .eq('seller_id', sellerId)
          .select('id')
          .maybeSingle();

      if (updated == null) {
        throw StateError('The product was not found or is not owned by you.');
      }
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct({required int productId}) async {
    final sellerId = _client.auth.currentUser?.id;
    if (sellerId == null) {
      throw StateError('A signed-in user is required to delete a product.');
    }

    try {
      final product = await _client
          .from('products')
          .select('main_image_url, variants:product_variants(image_url)')
          .eq('id', productId)
          .eq('seller_id', sellerId)
          .maybeSingle();

      if (product == null) {
        throw StateError('The product was not found or is not owned by you.');
      }

      final imagePaths = <String>{};
      final mainImagePath = product['main_image_url'] as String?;
      if (mainImagePath != null) imagePaths.add(mainImagePath);

      for (final variant in product['variants'] as List) {
        final path = (variant as Map)['image_url'] as String?;
        if (path != null) imagePaths.add(path);
      }

      final deleted = await _client
          .from('products')
          .delete()
          .eq('id', productId)
          .eq('seller_id', sellerId)
          .select('id')
          .maybeSingle();

      if (deleted == null) {
        throw StateError('The product could not be deleted.');
      }

      if (imagePaths.isNotEmpty) {
        try {
          await _client.storage.from(_bucket).remove(imagePaths.toList());
        } catch (cleanupError) {
          AppHelpers.logger().error(cleanupError);
        }
      }
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
