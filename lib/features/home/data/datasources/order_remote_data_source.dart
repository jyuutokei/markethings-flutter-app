import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/placed_order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class OrderRemoteDataSource {
  Future<PlacedOrderModel> placeOrder({required List<int> cartItemIds});
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
}
