import 'package:mt/features/home/domain/repositories/order_repository.dart';

class CancelOrder {
  final OrderRepository repository;

  const CancelOrder(this.repository);

  Future<void> call(int orderId) {
    return repository.cancelOrder(orderId);
  }
}
