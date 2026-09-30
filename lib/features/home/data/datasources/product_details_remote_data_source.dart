import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/product_details_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<ProductDetailsModel> getProductDetail(int productId);
}

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final SupabaseClient _client;

  const ProductDetailsRemoteDataSourceImpl(this._client);

  @override
  Future<ProductDetailsModel> getProductDetail(int productId) async {
    try {
      final response = await _client
          .from('products')
          .select(
            'id, title, description, main_image_url, '
            'product_variants(name, price, image_url, stock_quantity, attributes)',
          )
          .eq('id', productId)
          .single();

      return ProductDetailsModel.fromJson(response);
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
