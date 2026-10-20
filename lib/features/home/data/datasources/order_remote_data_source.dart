import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/order_card_model.dart';
import 'package:mt/features/home/data/models/placed_order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class OrderRemoteDataSource {
  Future<PlacedOrderModel> placeOrder({required List<int> cartItemIds});
  Future<List<OrderCardModel>> getOrderDetails();
  Future<void> cancelOrder(int orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final SupabaseClient _client;
  static const _bucket = 'products';

  const OrderRemoteDataSourceImpl(this._client);

  String? _toPublicUrl(String? path) {
    return path != null
        ? _client.storage.from(_bucket).getPublicUrl(path)
        : null;
  }

  @override
  Future<PlacedOrderModel> placeOrder({required List<int> cartItemIds}) async {
    try {
      final response = await _client.rpc(
        'place_order',
        params: {'p_cart_item_ids': cartItemIds},
      );

      return PlacedOrderModel.fromRpcResponse(response);
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<List<OrderCardModel>> getOrderDetails() async {
    try {
      final response = await _client
          .from('orders')
          .select(
            'id, status, created_at, '
            'order_items(id, product_id, variant_id, product_title, '
            'variant_name, unit_price, quantity, image_url)',
          )
          .order('created_at', ascending: false);

      return (response as List).map((row) {
        final orderJson = Map<String, dynamic>.from(row as Map);

        orderJson['order_items'] = (orderJson['order_items'] as List).map((
          item,
        ) {
          final itemJson = Map<String, dynamic>.from(item as Map);
          itemJson['image_url'] = _toPublicUrl(
            itemJson['image_url'] as String?,
          );
          return itemJson;
        }).toList();

        return OrderCardModel.fromJson(orderJson);
      }).toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<void> cancelOrder(int orderId) async {
    try {
      await _client.rpc('cancel_order', params: {'p_order_id': orderId});
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
