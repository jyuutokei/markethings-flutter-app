import 'package:mt/features/home/data/datasources/order_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/placed_order_entity.dart';
import 'package:mt/features/home/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  const OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<PlacedOrderEntity> placeOrder({required List<int> cartItemIds}) {
    return remoteDataSource.placeOrder(cartItemIds: cartItemIds);
  }
}
