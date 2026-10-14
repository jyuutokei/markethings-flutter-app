import 'package:equatable/equatable.dart';

class OrderLineItemEntity extends Equatable {
  final int id;
  final int? productId;
  final int? variantId;
  final String productTitle;
  final String variantName;
  final double unitPrice;
  final int quantity;
  final String? imageUrl;

  const OrderLineItemEntity({
    required this.id,
    this.productId,
    this.variantId,
    required this.productTitle,
    required this.variantName,
    required this.unitPrice,
    required this.quantity,
    this.imageUrl,
  });

  double get lineTotal => unitPrice * quantity;

  @override
  List<Object?> get props => [
    id,
    productId,
    variantId,
    productTitle,
    variantName,
    unitPrice,
    quantity,
    imageUrl,
  ];
}

class OrderCardEntity extends Equatable {
  final int id;
  final String status;
  final DateTime createdAt;
  final List<OrderLineItemEntity> items;

  const OrderCardEntity({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  double get total => items.fold(0, (sum, item) => sum + item.lineTotal);

  @override
  List<Object?> get props => [id, status, createdAt, items];
}
