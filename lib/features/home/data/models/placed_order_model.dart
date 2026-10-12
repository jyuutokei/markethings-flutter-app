import 'package:mt/features/home/domain/entities/placed_order_entity.dart';

class PlacedOrderModel extends PlacedOrderEntity {
  const PlacedOrderModel({required super.orderId});

  factory PlacedOrderModel.fromRpcResponse(Object? response) {
    if (response is! num) {
      throw const FormatException('Expected place_order to return an order ID');
    }

    return PlacedOrderModel(orderId: response.toInt());
  }
}
