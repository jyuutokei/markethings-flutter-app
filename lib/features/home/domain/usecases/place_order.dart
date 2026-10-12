import 'package:mt/features/home/domain/entities/placed_order_entity.dart';
import 'package:mt/features/home/domain/repositories/order_repository.dart';

class PlaceOrder {
  final OrderRepository repository;

  const PlaceOrder(this.repository);

  Future<PlacedOrderEntity> call({required List<int> cartItemIds}) {
    return repository.placeOrder(cartItemIds: cartItemIds);
  }
}
