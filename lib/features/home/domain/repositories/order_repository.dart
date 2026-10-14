import 'package:mt/features/home/domain/entities/order_card_entity.dart';
import 'package:mt/features/home/domain/entities/placed_order_entity.dart';

abstract class OrderRepository {
  Future<PlacedOrderEntity> placeOrder({required List<int> cartItemIds});
  Future<List<OrderCardEntity>> getOrderDetails();
  Future<void> cancelOrder(int orderId);
}
