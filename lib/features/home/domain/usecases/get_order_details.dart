import 'package:mt/features/home/domain/entities/order_card_entity.dart';
import 'package:mt/features/home/domain/repositories/order_repository.dart';

class GetOrderDetails {
  final OrderRepository repository;

  const GetOrderDetails(this.repository);

  Future<List<OrderCardEntity>> call() {
    return repository.getOrderDetails();
  }
}
