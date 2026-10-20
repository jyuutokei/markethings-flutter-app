import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/product_details_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<ProductDetailsModel> getProductDetail(int productId);
}

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final SupabaseClient _client;
  static const _bucket = 'products';

  const ProductDetailsRemoteDataSourceImpl(this._client);

  String? _toPublicUrl(String? path) {
    return path != null
        ? _client.storage.from(_bucket).getPublicUrl(path)
        : null;
  }

  @override
  Future<ProductDetailsModel> getProductDetail(int productId) async {
    try {
      final response = await _client
          .from('products')
          .select(
            'id, title, category_id, seller_id, description, main_image_url, '
            'variants:product_variants(id, product_id, name, price, image_url, stock_quantity, attributes), '
            'profile:profiles(display_name, store_name)',
          )
          .eq('id', productId)
          .order('price', referencedTable: 'variants', ascending: true)
          .single();

      final productJson = Map<String, dynamic>.from(response);

      productJson['main_image_url'] = _toPublicUrl(
        productJson['main_image_url'] as String?,
      );

      productJson['variants'] = (productJson['variants'] as List).map((
        variant,
      ) {
        final variantJson = Map<String, dynamic>.from(
          variant as Map<String, dynamic>,
        );

        variantJson['image_url'] = _toPublicUrl(
          variantJson['image_url'] as String?,
        );

        return variantJson;
      }).toList();

      return ProductDetailsModel.fromJson(productJson);
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
