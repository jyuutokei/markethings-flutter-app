import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/cart_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CartItemRemoteDataSource {
  Future<CartItemModel> addCartItem({
    required int variantId,
    required int quantity,
  });
}

class CartItemRemoteDataSourceImpl implements CartItemRemoteDataSource {
  final SupabaseClient _client;

  CartItemRemoteDataSourceImpl(this._client);

  @override
  Future<CartItemModel> addCartItem({
    required int variantId,
    required int quantity,
  }) async {
    try {
      final response = await _client.rpc(
        'add_cart_item',
        params: {'p_variant_id': variantId, 'p_quantity': quantity},
      );

      if (response is! Map) {
        throw const FormatException(
          'Expected add_to_cart to return one cart row',
        );
      }

      return CartItemModel.fromJson(Map<String, dynamic>.from(response));
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
