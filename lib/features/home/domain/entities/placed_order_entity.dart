import 'package:equatable/equatable.dart';

class PlacedOrderEntity extends Equatable {
  final int orderId;

  const PlacedOrderEntity({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
