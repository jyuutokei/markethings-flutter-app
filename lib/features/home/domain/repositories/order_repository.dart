import 'package:mt/features/home/domain/entities/placed_order_entity.dart';

abstract class OrderRepository {
  Future<PlacedOrderEntity> placeOrder({required List<int> cartItemIds});
}
