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

  const OrderRemoteDataSourceImpl(this._client);

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

      return (response as List)
          .map((row) => OrderCardModel.fromJson(row as Map<String, dynamic>))
          .toList();
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
