import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/cart_item_add_model.dart';
import 'package:mt/features/home/data/models/cart_item_details_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CartItemRemoteDataSource {
  Future<CartItemAddModel> addCartItem({required int variantId});
  Future<List<CartItemDetailsModel>> getCartItemDetails();
}

class CartItemRemoteDataSourceImpl implements CartItemRemoteDataSource {
  final SupabaseClient _client;

  CartItemRemoteDataSourceImpl(this._client);

  @override
  Future<CartItemAddModel> addCartItem({required int variantId}) async {
    try {
      final response = await _client.rpc(
        'add_cart_item',
        params: {'p_variant_id': variantId},
      );

      if (response is! Map) {
        throw const FormatException(
          'Expected add_cart_item to return one cart row',
        );
      }

      return CartItemAddModel.fromJson(Map<String, dynamic>.from(response));
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<List<CartItemDetailsModel>> getCartItemDetails() async {
    try {
      final response = await _client
          .from('cart_items')
          .select(
            'id, variant_id, quantity, '
            'variant:product_variants(name, price, image_url, product:products(title))',
          )
          .order('created_at', ascending: false);

      return (response as List)
          .map(
            (row) => CartItemDetailsModel.fromJson(row as Map<String, dynamic>),
          )
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
